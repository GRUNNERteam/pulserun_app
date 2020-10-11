part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoadded extends ScheduleState {
  final ScheduleListModel scheduleListModel;
  final Map<DateTime, List> mapCalendar;
  ScheduleLoadded({
    this.scheduleListModel,
    this.mapCalendar,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleLoadded &&
        o.scheduleListModel == scheduleListModel &&
        mapEquals(o.mapCalendar, mapCalendar);
  }

  @override
  int get hashCode => scheduleListModel.hashCode ^ mapCalendar.hashCode;
}

class ScheduleError extends ScheduleState {
  final String errormsg;
  ScheduleError({
    this.errormsg,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleError && o.errormsg == errormsg;
  }

  @override
  int get hashCode => errormsg.hashCode;
}
