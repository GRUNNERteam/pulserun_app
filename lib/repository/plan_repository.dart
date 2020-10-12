import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/schedule_repository.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:pulserun_app/services/database/database.dart';
import 'package:pulserun_app/services/generates/generate_schedule.dart';

abstract class PlanRepository {
  Future<PlanModel> fetchPlan();
  Future<List<PlanModel>> fetchPlanLists();
  Future<DocumentReference> getRef();

  Future<void> setRef();

  Future<ScheduleModel> fetchTodaySchedule();

  Future<void> createPlan(PlanModel plan);
  Future<void> deletePlan(String planId);
  Future<void> updatePlan(PlanModel plan);
}

class PlanData implements PlanRepository {
  DocumentReference _reference;
  ScheduleRespository _scheduleRespository = ScheduleData();

  @override
  Future<PlanModel> fetchPlan() async {
    PlanModel plan;

    await this.setRef();
    if (this._reference == null) {
      return null;
    }

    await _reference.get().then((snapShot) {
      if (snapShot.exists) {
        plan = PlanModel.fromMap(snapShot.data());
      }
    });

    return plan;
  }

  @override
  Future<DocumentReference> getRef() async {
    return this._reference;
  }

  @override
  Future<void> setRef() async {
    await DatabaseService()
        .getUserRef()
        .collection('stat')
        .doc('current')
        .get()
        .then((snapShot) {
      if (snapShot.data().isNotEmpty) {
        this._reference = snapShot.data()['planRef'];
      }
    });
  }

  @override
  Future<void> createPlan(PlanModel plan) async {
    DocumentReference planRef =
        DatabaseService().getUserRef().collection('plan').doc();
    DateTime dob;
    bool isPlanRefEmpty = true;
    ScheduleListModel scheduleListModel = ScheduleListModel();
    // Check before create
    try {
      await DatabaseService().getUserRef().get().then((snapShot) {
        if (!snapShot.exists || snapShot.data()['birthDate'] == null) {
          throw Exception('User or BirthDate not Exists');
        }
        dob = DateTime.parse(snapShot.data()['birthDate']);
      });
      print(plan.goal.toString());
      await planRef.set(
        plan.toMap(),
      );

      print('Updating planRef');

      await DatabaseService()
          .getUserRef()
          .collection('stat')
          .doc('current')
          .get()
          .then((snapshot) {
        if (snapshot.exists && snapshot.data()['planRef'] != null) {
          isPlanRefEmpty = false;
        } else {
          print('planRef already exists skip update.');
        }
      });

      if (isPlanRefEmpty) {
        await DatabaseService()
            .getUserRef()
            .collection('stat')
            .doc('current')
            .update({'planRef': planRef});
      }

      print('Updating Normal target heartRate');

      double thr = (220 - Jiffy(DateTime.now()).diff(dob, Units.YEAR)) * 0.5;

      await planRef.update({
        'planId': planRef.id,
        'targetHeartRate': thr.toInt(),
      });

      print('Creating Schedule');

      this._scheduleRespository = new ScheduleData();
      await this._scheduleRespository.setRef(planRef);
      await this._scheduleRespository.setPlanModel(plan);

      await this._scheduleRespository.create();

      print('Creating Plan successful');
    } catch (e) {
      print('Creating Plan failed : $e');
    }
  }

  @override
  Future<List<PlanModel>> fetchPlanLists() async {
    List<PlanModel> planList = List<PlanModel>();
    await DatabaseService()
        .getUserRef()
        .collection('plan')
        .get()
        .then((snapShotCollection) {
      if (snapShotCollection.size > 0) {
        snapShotCollection.docs.forEach((doc) {
          if (doc.exists && doc.data().isNotEmpty) {
            print(doc.data()['planId']);
            planList.add(PlanModel.fromMap(doc.data()));
          }
        });
      }
    });
    return planList;
  }

  @override
  Future<void> deletePlan(String planId) async {
    DocumentReference ref;
    await DatabaseService()
        .getUserRef()
        .collection('plan')
        .where('planId', isEqualTo: planId)
        .get()
        .then((snapshot) {
      if (snapshot.size > 0) {
        snapshot.docs.forEach((doc) {
          if (doc.data()['planId'] == planId) {
            String tempplanId = doc.data()['planId'];
            print('Found Plan : $tempplanId');

            ref = doc.reference;
          }
        });
      }
    });

    if (ref != null) {
      await DatabaseService()
          .getUserRef()
          .collection('stat')
          .doc('current')
          .get()
          .then((snapshot) {
        if (snapshot.data()['planRef'] == ref) {
          DatabaseService()
              .getUserRef()
              .collection('stat')
              .doc('current')
              .update(
            {
              'planRef': null,
            },
          );
        }
      });

      await ref.delete();
    }
  }

  @override
  Future<void> updatePlan(PlanModel plan) async {
    DocumentReference ref;
    await DatabaseService()
        .getUserRef()
        .collection('plan')
        .where('planId', isEqualTo: plan.planId)
        .get()
        .then((snapshot) {
      if (snapshot.size > 0) {
        snapshot.docs.forEach((doc) {
          if (doc.data()['planId'] == plan.planId) {
            String tempplanId = doc.data()['planId'];
            print('Found Plan : $tempplanId');

            ref = doc.reference;
          }
        });
      }
    });

    if (ref != null) {
      print(ref.toString());
      await ref.update(plan.toMap());
    }
  }

  @override
  Future<ScheduleModel> fetchTodaySchedule() async {
    if (_reference == null) {
      await this.setRef();
    }
    await this._scheduleRespository.setRef(this._reference);
    return await this._scheduleRespository.fetch();
  }
}
