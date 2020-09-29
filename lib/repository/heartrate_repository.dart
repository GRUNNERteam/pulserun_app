import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/running_repository.dart';

abstract class HeartRateRepository {
  Future<void> init();
  Future<void> insertdb(int hr);
}

class TestHeartRate implements HeartRateRepository {
  final PlanRepository _planRepository = MockUpPlan();
  DocumentReference _reference;
  RunningModel _runningModel;
  HeartRateModel _heartRateModel;

  @override
  Future<void> init() async {
    this._reference = await _planRepository.getRef(); //เอาแพลนไอดี
    this._reference = this._reference.collection('run').doc(idR);
    //this._reference = this._reference.collection(idR).doc();
    log(this._reference.path, name: 'HeartRate');
  }

  Future<void> insertdb(int hr) async {}
}
