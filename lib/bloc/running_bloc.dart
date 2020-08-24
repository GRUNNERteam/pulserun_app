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

part 'running_event.dart';
part 'running_state.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  final Location _location;
  final LocationRepository _locationRepository;

  StreamSubscription _locationSubscription;

  final PlanRepository _planRepository;
  final CurrentStatusRepository _currentStatusRepository;

  RunningBloc(
    this._location,
    this._planRepository,
    this._currentStatusRepository,
    this._locationRepository,
  ) : super(RunningInitial());

  @override
  Stream<RunningState> mapEventToState(
    RunningEvent event,
  ) async* {
    if (event is GetPlanAndStat) {
      try {
        debugPrint('GetPlanAndStat Event');
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
        _location.changeSettings(accuracy: LocationAccuracy.navigation);
        _locationSubscription?.cancel();
        _locationSubscription =
            _location.onLocationChanged.listen((LocationData currentLocation) {
          add(LocationChange(locationData: currentLocation));
        });
        final LocationData position = await _location.getLocation();
        yield RunningWorking(
            positionModel: PositionModel().convertLocToPos(position));
      } catch (e) {
        yield RunningError('StartRunning Error');
      }
    }

    if (event is LocationChange && state is RunningWorking) {
      yield RunningWorking(
          positionModel: PositionModel().convertLocToPos(event.locationData));
    }
    if (event is StopRunning) {
      try {
        yield RunningLoading();
        _locationSubscription?.cancel();
        yield RunningResult();
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
