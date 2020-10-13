part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final CurrentStatusModel currentStatusModel;
  final UserModel userModel;
  final ScheduleModel scheduleModel;
  final List<ResultModel> historyModel;
  // final ScheduleModel scheduleModel;
  const HomeLoaded(
    // this.scheduleModel,
    this.currentStatusModel,
    this.userModel,
    this.scheduleModel,
    this.historyModel,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeLoaded &&
        o.currentStatusModel == currentStatusModel &&
        o.userModel == userModel &&
        o.scheduleModel == scheduleModel &&
        o.historyModel == historyModel;
  }

  @override
  int get hashCode =>
      currentStatusModel.hashCode ^
      userModel.hashCode ^
      scheduleModel.hashCode ^
      historyModel.hashCode;
}

class HomeEmptyPlan extends HomeState {
  final CurrentStatusModel currentStatusModel;
  final UserModel userModel;
  HomeEmptyPlan({
    this.currentStatusModel,
    this.userModel,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeEmptyPlan &&
        o.currentStatusModel == currentStatusModel &&
        o.userModel == userModel;
  }

  @override
  int get hashCode => currentStatusModel.hashCode ^ userModel.hashCode;
}

class HomeRequestData extends HomeState {
  final CurrentStatusModel currentStatusModel;
  final UserModel userModel;
  const HomeRequestData(this.currentStatusModel, this.userModel);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeRequestData &&
        o.currentStatusModel == currentStatusModel &&
        o.userModel == userModel;
  }

  @override
  int get hashCode => currentStatusModel.hashCode ^ userModel.hashCode;
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
