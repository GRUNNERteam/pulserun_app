part of 'plan_bloc.dart';

@immutable
abstract class PlanEvent {}

class PlanCreating extends PlanEvent {
  final PlanModel planModel;
  PlanCreating({
    this.planModel,
  });
}

class GetPlan extends PlanEvent {
  final PlanModel planModel;
  final CurrentStatusModel currentStatusModel;
  GetPlan({
    this.planModel,
    this.currentStatusModel,
  });
}

class DeletePlan extends PlanEvent {}

class UpdatePlan extends PlanEvent {}
