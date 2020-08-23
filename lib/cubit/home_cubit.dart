import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository _userRepository;
  final CurrentStatusRepository _currentStatusRepository;
  HomeCubit(this._userRepository, this._currentStatusRepository)
      : super(HomeInitial());

  Future<void> getUser() async {
    try {
      emit(HomeLoading());
      final user = await _userRepository.fetchUser();
      final currentstatus = await _currentStatusRepository.fetchCurrentStatus();
      emit(HomeLoaded(currentstatus, user));
    } catch (err) {
      emit(HomeError('Unknows Error'));
    }
  }

  Future<void> changeBottomNav() async {
    try {
      emit(HomeLoading());
      final user = await _userRepository.fetchUser();
      final currentstatus = await _currentStatusRepository.fetchCurrentStatus();
      emit(HomeLoaded(currentstatus, user));
    } catch (err) {
      emit(HomeError('ChangeBottomNav Error'));
    }
  }
}
