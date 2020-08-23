part of 'running_cubit.dart';

@immutable
abstract class RunningState {}

class RunningInitial extends RunningState {}

class RunningLoading extends RunningState {}

class RunningLoaded extends RunningState {}

class RunningWorking extends RunningState {}

class RunningResult extends RunningState {}

class RunningError extends RunningState {
  final String message;

  RunningError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
