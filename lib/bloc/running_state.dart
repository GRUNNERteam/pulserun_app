part of 'running_bloc.dart';

@immutable
abstract class RunningState {
  const RunningState();
}

class RunningInitial extends RunningState {
  const RunningInitial();
}

class RunningLoading extends RunningState {
  const RunningLoading();
}

class RunningLoaded extends RunningState {
  final PlanModel planModel;
  final CurrentStatusModel currentStatusModel;

  const RunningLoaded(
    this.planModel,
    this.currentStatusModel,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningLoaded &&
        o.planModel == planModel &&
        o.currentStatusModel == currentStatusModel;
  }

  @override
  int get hashCode => planModel.hashCode ^ currentStatusModel.hashCode;
}

class RunningWorking extends RunningState {
  RunningModel runningModel;
  RunningWorking({
    this.runningModel,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningWorking && o.runningModel == runningModel;
  }

  @override
  int get hashCode => runningModel.hashCode;
}

class RunningResult extends RunningState {}

class RunningError extends RunningState {
  final String message;

  const RunningError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}