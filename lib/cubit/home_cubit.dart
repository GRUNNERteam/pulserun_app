import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:intl/intl.dart';
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
      if (user.birthDate == null ||
          currentstatus.weight == null ||
          currentstatus.height == null) {
        print("HomeRequestData State");
        emit(HomeRequestData(currentstatus, user));
      } else {
        emit(HomeLoaded(currentstatus, user));
      }
    } catch (err) {
      emit(HomeError('Unknows Error'));
    }
  }

  Future<void> updateUser({
    DateTime dob,
    double height,
    double weight,
  }) async {
    try {
      emit(HomeLoading());
      if (dob != null) {
        await _userRepository.updateUserDoB(dob);
      }

      if (height != null && weight != null) {
        await _currentStatusRepository.updateUserHW(height, weight);
      }

      // callback to get user
      await getUser();
    } catch (err) {
      emit(HomeError('updateUser Error'));
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
