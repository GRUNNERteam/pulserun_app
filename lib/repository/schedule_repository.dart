import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/services/generates/generate_schedule.dart';
import 'package:pulserun_app/services/generates/generate_schedule_goal.dart';

abstract class ScheduleRespository {
  Future<ScheduleListModel> fetchLists();
  Future<ScheduleModel> fetch();

  Future<void> update(ScheduleModel scheduleModel);
  Future<void> create();

  // Ref
  Future<CollectionReference> getRef();

  Future<void> setRef(DocumentReference ref);
  Future<void> setPlanModel(PlanModel plan);
}

class ScheduleData implements ScheduleRespository {
  List<DocumentReference> _documentReference = [];
  CollectionReference _collectionReference;
  ScheduleListModel _scheduleListModel;
  ScheduleModel _scheduleModel;
  ScheduleGoalModel _scheduleGoalModel;
  PlanModel _plan;

  @override
  Future<void> create() async {
    if (this._plan == null) {
      print('ScheduleRespository : _plan is null');
      return;
    }

    if (this._collectionReference == null) {
      print('ScheduleRespository : _collectionReference is null');
      return;
    }

    ScheduleListModel lists =
        await GenerateScheduleService().generateScheduleWeekly(this._plan);

    lists.scheduleList.forEach((element) {
      try {
        this._collectionReference.doc().set(element.toMap());
      } catch (e) {
        print('Error createing schedule to DB : $e');
      }
    });
  }

  @override
  Future<ScheduleModel> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<ScheduleListModel> fetchLists() async {
    ScheduleListModel scheduleListModel;

    return scheduleListModel;
  }

  @override
  Future<void> update(ScheduleModel scheduleModel) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<CollectionReference> getRef() async {
    return await this._collectionReference;
  }

  @override
  Future<void> setRef(DocumentReference ref) async {
    this._collectionReference = ref.collection('schedule');
  }

  @override
  Future<void> setPlanModel(PlanModel plan) async {
    this._plan = plan;
  }
}
