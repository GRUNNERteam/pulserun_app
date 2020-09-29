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
  final double distance;
  final PositionModel positionModel;
  final int heartrate;
  RunningWorking({
    this.distance,
    this.positionModel,
    this.heartrate,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningWorking &&
        o.distance == distance &&
        o.positionModel == positionModel &&
        o.heartrate == heartrate;
  }

  @override
  int get hashCode =>
      distance.hashCode ^ positionModel.hashCode ^ heartrate.hashCode;
}

class RunningDisplayChange extends RunningState {
  final PositionModel positionModel;
  final double distance;
  final int hearrate;
  const RunningDisplayChange(
    this.positionModel,
    this.distance,
    this.hearrate,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningDisplayChange &&
        o.positionModel == positionModel &&
        o.distance == distance &&
        o.hearrate == hearrate;
  }

  @override
  int get hashCode =>
      positionModel.hashCode ^ distance.hashCode ^ hearrate.hashCode;
}

class RunningResult extends RunningState {
  final RunningModel runningModel;
  final LocationServiceAndTracking locationServiceAndTracking;
  RunningResult({
    this.runningModel,
    this.locationServiceAndTracking,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningResult &&
        o.runningModel == runningModel &&
        o.locationServiceAndTracking == locationServiceAndTracking;
  }

  @override
  int get hashCode =>
      runningModel.hashCode ^ locationServiceAndTracking.hashCode;
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
