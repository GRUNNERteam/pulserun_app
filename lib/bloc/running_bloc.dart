import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/heartrate_repository.dart';
import 'package:pulserun_app/repository/location_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/result_repository.dart';
import 'package:pulserun_app/repository/running_repository.dart';
import 'package:pulserun_app/repository/schedule_repository.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:pulserun_app/screens/running/running.dart';
import 'package:rxdart/rxdart.dart';

part 'running_event.dart';
part 'running_state.dart';

//https://github.com/amugofjava/provider-bloc-example/tree/master/lib
class RunningBloc extends Bloc<RunningEvent, RunningState> {
  final Location _location;
  final RunningRepository _runningRepository;

  StreamSubscription _locationSubscription;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  StreamSubscription _stopwatchSubscription;
  final Stopwatch _stopwatch = Stopwatch();

  /// The current state of the stopwatch: stop, start or reset.
  final BehaviorSubject<RunningState> _stopwatchState =
      BehaviorSubject<RunningState>.seeded(RunningResult());

  /// The current time of the stopwatch. We seed it with 00:00:00 so that we have a value on first run.
  final BehaviorSubject<String> stopwatchTime =
      BehaviorSubject<String>.seeded('00:00:00');

  final PlanRepository _planRepository;
  final ScheduleRespository _scheduleRespository;
  final CurrentStatusRepository _currentStatusRepository;

  final HeartRateRepository _heartRateRepository;
  final UserRepository _userRepository;
  final ResultRepository _resultRepository;

  RunningBloc(
    this._location,
    this._runningRepository,
    this._planRepository,
    this._currentStatusRepository,
    this._heartRateRepository,
    this._userRepository,
    this._resultRepository,
    this._scheduleRespository,
  ) : super(RunningInitial()) {
    _setupStopWatch();
  }
  // setup stopWatch

  _setupStopWatch() {
    _stopwatchState.listen((event) {
      switch (event.runtimeType) {
        case RunningWorking:
          print('Start stopwatch');
          _start();
          break;
        case RunningResult:
          print('Stop stopwatch');
          _stop();
          break;
        case RunningLoading:
          print('Reset stopwatch');
          _reset();
          break;
      }
    });
  }

  @override
  Stream<RunningState> mapEventToState(
    RunningEvent event,
  ) async* {
    if (event is GetPlanAndStat) {
      try {
        _reset();
        UserModel user = await _userRepository.fetchUser();
        _location.changeSettings(accuracy: LocationAccuracy.navigation);
        yield RunningLoading();
        final plan = await _planRepository.fetchPlan();
        final stat = await _currentStatusRepository.fetchCurrentStatus();
        await this._scheduleRespository.setRef(stat.planRef);
        final schdeule = await _scheduleRespository.fetch();
        yield RunningLoaded(plan, stat, user, schdeule);
      } catch (e) {
        yield RunningError('Can not get Plan and CurrentStatus');
      }
    }

    if (event is StartRunning) {
      try {
        yield RunningLoading();
        _start();

        _serviceEnabled = await _location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await _location.requestService();
          if (!_serviceEnabled) {
            add(GetPlanAndStat());
          }
        }

        _permissionGranted = await _location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await _location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            add(GetPlanAndStat());
          }
        }

        _locationSubscription?.cancel();
        print('_location getLocation');
        final LocationData position = await _location.getLocation();
        print(position);
        await _runningRepository.init();
        print('init Running Completed');

        final double distance = await _runningRepository
            .working(PositionModel().convertLocToPos(position));
        print(distance);
        final UserModel userModel = await _userRepository.fetchUser();
        final int targetHR = userModel.targetHeartrate;
        characteristic.setNotifyValue(true);
        yield RunningWorking(
          positionModel: PositionModel().convertLocToPos(position),
          distance: 0.toDouble(),
          targetheartrate: targetHR,
        );

        _locationSubscription =
            _location.onLocationChanged.listen((LocationData currentLocation) {
          add(LocationChange(locationData: currentLocation));
        });
      } catch (e) {
        print('StartRunning Error : $e');
        yield RunningError('StartRunning Error');
      }
    }

    if (event is LocationChange) {
      try {
        final double distance = await _runningRepository
            .working(PositionModel().convertLocToPos(event.locationData));
        final hr = 0;
        final UserModel userModel = await _userRepository.fetchUser();
        final int targetHR = userModel.targetHeartrate;

        yield RunningDisplayChange(
          PositionModel().convertLocToPos(event.locationData),
          distance,
          hr,
          targetHR,
        );
      } catch (e) {
        print('LocationChange Error : $e');
        yield RunningError('Location Error');
      }
    }

    if (event is StopRunning) {
      try {
        ResultModel _resultModel = ResultModel();

        yield RunningLoading();
        this.stopwatchTime.asyncMap((event) => null);
        _stop();
        _locationSubscription?.cancel();
        String et = await stopwatchTime.first;
        await _runningRepository.setestimatedTime(et);
        await _runningRepository.stop();
        await _resultRepository.setRef(_runningRepository.gettReference());
        _resultModel = await _resultRepository.getResult();
        //characteristic.setNotifyValue(false);
        await _currentStatusRepository
            .updateDistance(_resultModel.totalDdistance);
        yield RunningResult(
            locationServiceAndTracking: event.locationServiceAndTracking,
            runningModel: event.runningModel,
            resultModel: _resultModel);
      } catch (e) {
        loggerNoStack.e(e.toString());
        yield RunningError('StopRunning Error');
      }
    }
  }

  void _start() {
    _stopwatch.start();

    _stopwatchSubscription =
        Stream.periodic(Duration(milliseconds: 50)).listen((tick) {
      final elapsed = _stopwatch.elapsed;

      final int hundreds = (elapsed.inMilliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();

      String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
      String minutesStr = (minutes % 60).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      var t = '$minutesStr:$secondsStr:$hundredsStr';

      stopwatchTime.add(t);
    });
  }

  /// We stop the stopwatch and then cancel the subscription. There is no point the
  /// Observable firing every 50 milliseconds if there is no-one listening to it.
  void _stop() {
    _stopwatch.stop();

    if (_stopwatchSubscription != null) {
      _stopwatchSubscription.cancel();
    }
  }

  /// Reset the stopwatch back to zero.
  void _reset() {
    _stopwatch.reset();

    /// Push out our reset time.
    stopwatchTime.add('00:00:00');

    /// Put as back to the stopped state.
    _stopwatchState.add(RunningResult());
  }

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    _stopwatchSubscription.cancel();
    stopwatchTime.close();
    _stopwatchState.close();
    return super.close();
  }
}
