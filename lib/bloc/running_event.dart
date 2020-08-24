part of 'running_bloc.dart';

@immutable
abstract class RunningEvent {}

class GetPlanAndStat extends RunningEvent {
  final PlanModel planModel;
  final CurrentStatusModel currentStatusModel;
  GetPlanAndStat({
    this.planModel,
    this.currentStatusModel,
  });
}

class StartRunning extends RunningEvent {
  final RunningModel runningModel;
  StartRunning({
    this.runningModel,
  });
}

class LocationChange extends RunningEvent {
  final LocationData locationData;
  LocationChange({
    this.locationData,
  });
}

class StopRunning extends RunningEvent {}
