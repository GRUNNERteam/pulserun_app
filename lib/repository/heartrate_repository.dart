import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/repository/plan_repository.dart';

import 'package:pulserun_app/screens/running/running.dart';

abstract class HeartRateRepository {
  Future<void> init(DocumentReference ref);
  Future<void> addDB();
}

class TestHeartRate implements HeartRateRepository {
  DocumentReference _reference;

  @override
  Future<void> init(DocumentReference ref) async {
    this._reference = ref;
  }

  Future<void> addDB() async {
    this
        ._reference
        .collection('heartrate')
        .doc('heartrate')
        .set(heartRateModel.toMap());
  }
}
