import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/services/database/database.dart';

class StatisticModel extends ChangeNotifier {
  DocumentReference _ref;
  CurrentStatusModel _currentStatus = CurrentStatusModel();

  CurrentStatusModel get currentStatus => _currentStatus;

  StatisticModel() {
    this._ref = DatabaseService()
        .getUserRef()
        .collection('statisticCollection')
        .doc('statistic');

    _initDB();
  }

  void _initDB() async {
    await this._ref.get().then((snapshot) {
      if (!snapshot.exists) {
        _ref.set(this.getAllData());
      } else {
        print('statistic Already Existing, Retriveing data ...');
        Map<String, dynamic> data = snapshot.data();
        // data.forEach((key, value) {
        //   print('${key} : ${value}');
        // });
        if (data['currentStatus'] == null) {
          this._ref.update(this.getAllData());
          this._ref.get().then((snapshot) {
            Map<String, dynamic> data = snapshot.data();
            this._currentStatus.setCurrentStatus(data['currentStatus']);
          });
        } else {
          this._currentStatus.setCurrentStatus(data['currentStatus']);
        }
        notifyListeners();
      }
    });
  }

  CurrentStatusModel getCurrentStatus() {
    return getCurrentStatus();
  }

  DocumentReference getRef() {
    return this._ref;
  }

  Map<String, dynamic> getAllData() {
    print('Getting all Statistic DataModel');
    return {
      'currentStatus': _currentStatus.getAllData(),
    };
  }
}
