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
  Future<void> insertdb();
  Future<int> gethr();
}

class TestHeartRate implements HeartRateRepository {
  final PlanRepository _planRepository = MockUpPlan();
  DocumentReference _reference;
  HeartRateModel _heartRateModel;
  HeartRateItem _heartRateItem;

  @override
  Future<void> init() async {
    this._reference = await _planRepository.getRef(); //เอาแพลนไอดี
    this._reference = this._reference.collection('run').doc(idR);
    //this._reference = this._reference.collection(idR).doc();
    log(this._reference.path, name: 'HeartRate');
  }

  Future<void> insertdb() async {
    _heartRateItem.hr = 5;
    _heartRateItem.ts = new DateTime.now();
    log(_heartRateItem.hr.toString(), name: 'HeartRate');
    //log(_heartRateItem.ts.toString(), name: 'HeartRate');
  }

  Future<int> gethr() async {
    int value;
    StreamBuilder(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        if (snapshot.data
                .toString()
                .split(',')
                .last
                .split(']')
                .first
                .toString() ==
            '[') {
          value = 0;
        } else if (snapshot.hasData) {
          value = int.parse((snapshot.data
              .toString()
              .split(',')
              .last
              .split(']')
              .first
              .toString()));
          log(value.toString(), name: 'HeartRate1');
        }
      },
    );
    return value;
  }
}
