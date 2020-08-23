import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class PlanRepository {
  Future<PlanModel> fetchPlan();
}

class MockUpPlan implements PlanRepository {
  @override
  Future<PlanModel> fetchPlan() async {
    // ref doc zero for mockup plan
    int planid = 0;
    DocumentReference _ref = DatabaseService()
        .getUserRef()
        .collection('plan')
        .doc(planid.toString());

    PlanModel data;

    await _ref.get().then((snapshot) {
      if (snapshot.exists) {
        data = PlanModel.fromMap(snapshot.data());
      } else {
        // Createing Plan
        data = PlanModel(
            planId: planid, targetHeartRate: 180, start: DateTime.now());

        _ref.set(data.toMap());
      }
    });

    return data;
  }
}
