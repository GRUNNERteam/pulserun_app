import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/services/database/database.dart';

class PlanModel extends ChangeNotifier {
  int _planId;
  double _targetHeartRate;
  Timestamp _start;
  //RunningModel _progress = RunningModel();
  CollectionReference _ref;
  PlanModel() {
    // Mock up Data
    this._ref = DatabaseService()
        .getUserRef()
        .collection('statisticCollection')
        .doc('statistic')
        .collection('plans');

    this._planId = 0;
    this._targetHeartRate = 120;
    this._start = Timestamp.fromDate(DateTime(2020, 5, 5));
    _initDB();
  }
  void _initDB() async {
    await this._ref.doc(this._planId.toString()).get().then((snapshot) {
      if (!snapshot.exists) {
        _ref.doc(this._planId.toString()).set(this.getAllData());
      } else {
        print('plan Already Existing, Retriveing data ...');
        _ref.doc(this._planId.toString()).get().then((snapshot) {
          Map<String, dynamic> data = snapshot.data();
          this._planId = data['planId'];
          this._targetHeartRate = data['targetHeartRate'];
          this._start = data['start'];
        });
      }
    });
  }

  Map<String, dynamic> getAllData() {
    return {
      'planId': this._planId,
      'targetHeartRate': this._targetHeartRate,
      'start': this._start,
      //'progress': null,
    };
  }
}
