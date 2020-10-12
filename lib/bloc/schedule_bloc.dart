import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/schedule_repository.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRespository _scheduleRespository;
  final CurrentStatusRepository _currentStatusRepository;
  ScheduleBloc(
    this._scheduleRespository,
    this._currentStatusRepository,
  ) : super(ScheduleInitial());

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    if (event is GetScheduleList) {
      try {
        yield ScheduleLoading();
        final DocumentReference ref =
            await _currentStatusRepository.getPlanRef();
        await _scheduleRespository.setRef(ref);
        final ScheduleListModel scheduleListModel =
            await _scheduleRespository.fetchLists();
        Map<DateTime, List> mapCalendar = {};
        await Future.forEach(scheduleListModel.scheduleList,
            (ScheduleModel model) {
          Map<DateTime, List> mapCalendarTemp = {
            model.calendarModel.appointment: model.calendarModel.events
          };
          mapCalendar = {
            ...mapCalendar,
            ...mapCalendarTemp,
          };
        });
        yield ScheduleLoadded(
            scheduleListModel: scheduleListModel, mapCalendar: mapCalendar);
      } catch (e) {
        print('GetScheduleList : $e');
        yield ScheduleError();
      }
    }
  }
}
