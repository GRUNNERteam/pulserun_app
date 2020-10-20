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
  final UserModel userModel;
  final ScheduleModel scheduleModel;

  const RunningLoaded(
    this.planModel,
    this.currentStatusModel,
    this.userModel,
    this.scheduleModel,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningLoaded &&
        o.planModel == planModel &&
        o.currentStatusModel == currentStatusModel &&
        o.userModel == userModel &&
        o.scheduleModel == scheduleModel;
  }

  @override
  int get hashCode {
    return planModel.hashCode ^
        currentStatusModel.hashCode ^
        userModel.hashCode ^
        scheduleModel.hashCode;
  }
}

class RunningWorking extends RunningState {
  final double distance;
  final PositionModel positionModel;
  final int heartrate;
  final int targetheartrate;
  RunningWorking({
    this.distance,
    this.positionModel,
    this.heartrate,
    this.targetheartrate,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningWorking &&
        o.distance == distance &&
        o.positionModel == positionModel &&
        o.heartrate == heartrate &&
        o.targetheartrate == targetheartrate;
  }

  @override
  int get hashCode =>
      distance.hashCode ^
      positionModel.hashCode ^
      heartrate.hashCode ^
      targetheartrate.hashCode;
}

class RunningDisplayChange extends RunningState {
  final PositionModel positionModel;
  final double distance;
  final int hearrate;
  final targetheartrate;
  const RunningDisplayChange(
    this.positionModel,
    this.distance,
    this.hearrate,
    this.targetheartrate,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningDisplayChange &&
        o.positionModel == positionModel &&
        o.distance == distance &&
        o.hearrate == hearrate &&
        o.targetheartrate == targetheartrate;
  }

  @override
  int get hashCode =>
      positionModel.hashCode ^
      distance.hashCode ^
      hearrate.hashCode ^
      targetheartrate.hashCode;
}

class RunningResult extends RunningState {
  final RunningModel runningModel;
  final LocationServiceAndTracking locationServiceAndTracking;
  final ResultModel resultModel;
  RunningResult({
    this.runningModel,
    this.locationServiceAndTracking,
    this.resultModel,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningResult &&
        o.runningModel == runningModel &&
        o.locationServiceAndTracking == locationServiceAndTracking &&
        o.resultModel == resultModel;
  }

  @override
  int get hashCode =>
      runningModel.hashCode ^
      locationServiceAndTracking.hashCode ^
      resultModel.hashCode;
}

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
