import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/location_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/running_repository.dart';

part 'running_event.dart';
part 'running_state.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  final Location _location;
  final RunningRepository _runningRepository;

  StreamSubscription _locationSubscription;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  final PlanRepository _planRepository;
  final CurrentStatusRepository _currentStatusRepository;

  RunningBloc(
    this._location,
    this._runningRepository,
    this._planRepository,
    this._currentStatusRepository,
  ) : super(RunningInitial());

  @override
  Stream<RunningState> mapEventToState(
    RunningEvent event,
  ) async* {
    if (event is GetPlanAndStat) {
      try {
        _location.changeSettings(accuracy: LocationAccuracy.navigation);
        yield RunningLoading();
        final plan = await _planRepository.fetchPlan();
        final stat = await _currentStatusRepository.fetchCurrentStatus();
        yield RunningLoaded(plan, stat);
      } catch (e) {
        yield RunningError('Can not get Plan and CurrentStatus');
      }
    }

    if (event is StartRunning) {
      try {
        yield RunningLoading();

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
        yield RunningWorking(
            positionModel: PositionModel().convertLocToPos(position),
            distance: 0.toDouble());

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
        yield RunningDisplayChange(
            PositionModel().convertLocToPos(event.locationData), distance);
      } catch (e) {
        print('LocationChange Error : $e');
        yield RunningError('Location Error');
      }
    }

    if (event is StopRunning) {
      try {
        yield RunningLoading();
        _locationSubscription?.cancel();
        await _runningRepository.stop();
        yield RunningResult(
            locationServiceAndTracking: event.locationServiceAndTracking,
            runningModel: event.runningModel);
      } catch (e) {
        yield RunningError('StopRunning Error');
      }
    }
  }

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }
}
