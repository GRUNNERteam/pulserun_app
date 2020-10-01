part of 'plan_bloc.dart';

@immutable
abstract class PlanState {
  const PlanState();
}

class PlanInitial extends PlanState {
  const PlanInitial();
}

class PlanLoading extends PlanState {
  const PlanLoading();
}

class PlanCreate extends PlanState {
  const PlanCreate();
}

class PlanLoaded extends PlanState {
  final PlanModel planModel;
  final CurrentStatusModel currentStatusModel;
  const PlanLoaded({
    this.planModel,
    this.currentStatusModel,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlanLoaded &&
        o.planModel == planModel &&
        o.currentStatusModel == currentStatusModel;
  }

  @override
  int get hashCode => planModel.hashCode ^ currentStatusModel.hashCode;
}

class PlanError extends PlanState {
  const PlanError();
}
