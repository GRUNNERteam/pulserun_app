import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:pulserun_app/screens/plan/components/plan_detail.dart';

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
          //yield PlanLoaded(planModel: plan, currentStatusModel: status);
        }
      } catch (err) {
        print(err);
        yield PlanError();
      }
    }
    if (event is GetPlanLists) {
      try {
        yield PlanLoading();
        CurrentStatusModel status =
            await _currentStatusRepository.fetchCurrentStatus();
        if (status.planRef == null) {
          yield PlanCreate();
        } else {
          List<PlanModel> planLists = await _planRepository.fetchPlanLists();
          yield PlanLoaded(planLists: planLists, currentStatusModel: status);
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

        add(GetPlanLists());
      } catch (err) {
        print(err);
        yield PlanError();
      }
    }
    if (event is PlanCreatingTrigger) {
      try {
        yield PlanLoading();
        yield PlanCreate();
      } catch (e) {
        print('Error PlanCreatingTrigger : $e');
        yield PlanError();
      }
    }

    if (event is ShowPlanDetail) {
      try {
        yield PlanLoading();
        yield PlanDetail(event.planModel);
      } catch (e) {
        print('Error PlanCreatingTrigger : $e');
        yield PlanError();
      }
    }

    if (event is GetPlanById) {
      try {
        yield PlanLoading();
        PlanModel plan = await _planRepository.fetchPlan();
        if (plan == null) {
          add(PlanCreatingTrigger());
        } else {
          yield PlanDetail(plan);
        }
      } catch (e) {
        print('Error GetPlanById : $e');
        yield PlanError();
      }
    }
    if (event is UpdatePlan) {
      try {
        yield PlanLoading();
        await _planRepository.updatePlan(event.planModel);
        add(GetPlanLists());
      } catch (e) {
        print('Error UpdatePlan : $e');
        yield PlanError();
      }
    }
    if (event is DeletePlan) {
      try {
        yield PlanLoading();
        await _planRepository.deletePlan(event.planId);
        add(GetPlanLists());
      } catch (e) {
        print('Error DeletePlan : $e');
        yield PlanError();
      }
    }
  }
}
