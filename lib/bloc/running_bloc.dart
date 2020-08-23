import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/services/trackloc/trackloc.dart';

part 'running_event.dart';
part 'running_state.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  // location tracking
  final _tracklocStreamController = StreamController<TrackingLocationService>();
  // ignore: non_constant_identifier_names
  StreamSink<TrackingLocationService> get trackloc_sink =>
      _tracklocStreamController.sink;
  // ignore: non_constant_identifier_names
  Stream<TrackingLocationService> get trackloc_stream =>
      _tracklocStreamController.stream;
  // ignore: non_constant_identifier_names
  final _tracklocEventController = StreamController<RunningEvent>();
  // ignore: non_constant_identifier_names
  Sink<RunningEvent> get trackloc_event_sink => _tracklocEventController.sink;

  final PlanRepository _planRepository;
  final CurrentStatusRepository _currentStatusRepository;

  RunningBloc(
    this._planRepository,
    this._currentStatusRepository,
  ) : super(RunningInitial()) {
    _tracklocEventController.stream.listen((event) {});
  }

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
        yield RunningWorking();
      } catch (e) {
        yield RunningError('StartRunning Error');
      }
    }

    if (event is StopRunning) {
      try {
        yield RunningLoading();
        yield RunningResult();
      } catch (e) {
        yield RunningError('StopRunning Error');
      }
    }
  }

  dispose() {
    _tracklocStreamController.close();
    _tracklocEventController.close();
  }
}
