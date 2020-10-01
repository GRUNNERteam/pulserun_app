import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final PlanRepository _planRepository;
  final CurrentStatusRepository _currentStatusRepository;
  PlanBloc(
    this._planRepository,
    this._currentStatusRepository,
  ) : super(PlanInitial());

  @override
  Stream<PlanState> mapEventToState(
    PlanEvent event,
  ) async* {
    if (event is GetPlan) {
      try {
        yield PlanLoading();
        CurrentStatusModel status =
            await _currentStatusRepository.fetchCurrentStatus();
        if (status.planRef == null) {
          yield PlanCreate();
        } else {
          PlanModel plan = await _planRepository.fetchPlan();
          yield PlanLoaded(planModel: plan, currentStatusModel: status);
        }
      } catch (err) {
        print(err);
        yield PlanError();
      }
    }

    if (event is PlanCreating) {
      try {
        yield PlanLoading();

        await _planRepository.createPlan(
          PlanModel(
            goal: event.planModel.goal,
            start: DateTime.now(),
            breakDay: event.planModel.breakDay,
          ),
        );

        add(GetPlan());
      } catch (err) {
        print(err);
        yield PlanError();
      }
    }
  }
}
