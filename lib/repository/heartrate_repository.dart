import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/running_repository.dart';
import 'package:pulserun_app/screens/running/running.dart';

abstract class HeartRateRepository {
  Future<void> init(DocumentReference ref);
  Future<void> addDB();
}

class TestHeartRate implements HeartRateRepository {
  final PlanRepository _planRepository = PlanData();
  DocumentReference _reference;

  @override
  Future<void> init(DocumentReference ref) async {
    this._reference = ref;

    loggerNoStack.i(this._reference.path);
  }

  Future<void> addDB() async {
    this
        ._reference
        .collection('heartrate')
        .doc('heartrate')
        .set(heartRateModel.toMap());
  }
}
