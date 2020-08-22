import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pulserun_app/repository/location_repository.dart';

part 'running_state.dart';

class RunningCubit extends Cubit<RunningState> {
  final LocationRepository _locationRepository;
  RunningCubit(this._locationRepository) : super(RunningInitial());
  Future<void> getPlan() async {
    try {
      emit(RunningLoading());
      // mockup Plan
      emit(RunningLoaded());
    } catch (err) {
      emit(RunningError('State Error'));
    }
  }

  Future<void> startRun() async {
    try {
      emit(RunningLoading());
      emit(RunningWorking());
    } catch (err) {
      emit(RunningError('startRun Error'));
    }
  }
}
