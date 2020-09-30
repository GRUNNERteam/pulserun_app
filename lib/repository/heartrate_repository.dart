import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/running_repository.dart';
import 'package:pulserun_app/screens/running/running.dart';

abstract class HeartRateRepository {
  Future<void> init();
  Future<void> addDB();
}

class TestHeartRate implements HeartRateRepository {
  final PlanRepository _planRepository = MockUpPlan();
  DocumentReference _reference;

  @override
  Future<void> init() async {
    this._reference = await _planRepository.getRef(); //เอาแพลนไอดี
    this._reference = this._reference.collection('run').doc(idR);
    //this._reference = this._reference.collection(idR).doc();
    loggerNoStack.i(this._reference.path);
  }

  Future<void> addDB() async {
    _reference.collection('heartrate').doc().set(heartRateModel.toMap());
  }
}
