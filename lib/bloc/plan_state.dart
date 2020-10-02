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
  final List<PlanModel> planLists;
  final CurrentStatusModel currentStatusModel;
  const PlanLoaded({
    this.planLists,
    this.currentStatusModel,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlanLoaded &&
        listEquals(o.planLists, planLists) &&
        o.currentStatusModel == currentStatusModel;
  }

  @override
  int get hashCode => planLists.hashCode ^ currentStatusModel.hashCode;
}

class PlanDetail extends PlanState {
  final PlanModel planModel;
  const PlanDetail(
    this.planModel,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlanDetail && o.planModel == planModel;
  }

  @override
  int get hashCode => planModel.hashCode;
}

class PlanError extends PlanState {
  const PlanError();
}
