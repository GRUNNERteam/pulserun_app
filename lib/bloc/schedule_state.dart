part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoadded extends ScheduleState {
  final ScheduleListModel scheduleListModel;
  ScheduleLoadded({
    this.scheduleListModel,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleLoadded && o.scheduleListModel == scheduleListModel;
  }

  @override
  int get hashCode => scheduleListModel.hashCode;
}

class ScheduleError extends ScheduleState {}
