import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class CurrentStatusRepository {
  Future<CurrentStatusModel> fetchCurrentStatus();

  Future<double> fetchDistanceToCurrentStatus();

  Future<void> updateDistance(double value);
  Future<void> updateUserHW(double height, double weight);
  Future<DocumentReference> getPlanRef();
}

class CurrentStatus implements CurrentStatusRepository {
  DocumentReference _reference =
      DatabaseService().getUserRef().collection('stat').doc('current');

  @override
  Future<CurrentStatusModel> fetchCurrentStatus() async {
    CurrentStatusModel data;

    await _reference.get().then((snapshot) {
      if (snapshot.exists) {
        data = CurrentStatusModel.fromMap(snapshot.data());
        if (data.height != null && data.weight != null) {
          // https://www.thecalculatorsite.com/articles/health/bmi-formula-for-bmi-calculations.php
          double hpow = pow(data.height / 100, 2);
          print(hpow);
          double bmi = (data.weight / hpow);
          if (bmi < 18.5) {
            data.status = 'Underweight';
          } else if (bmi >= 18.5 && bmi < 25) {
            data.status = 'Normal';
          } else if (bmi >= 25 && bmi < 30) {
            data.status = 'Overweight';
          } else if (bmi > 30) {
            data.status = 'Obesity';
          }
          data.bmi = bmi;
          _reference.update({
            'bmi': bmi,
            'status': data.status,
          });
        }
      } else {
        // init value
        _reference.set(
            CurrentStatusModel(bmi: 0, status: 'UNKOWNS', distance: 0).toMap());
        data = CurrentStatusModel(bmi: 0, status: 'UNKOWNS', distance: 0);
      }
    });
    return data;
  }

  @override
  Future<double> fetchDistanceToCurrentStatus() async {
    double data;
    CollectionReference _ref =
        DatabaseService().getUserRef().collection('plan');

    await _ref.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        DocumentReference docRef = doc.reference;
      });
    });
  }

  @override
  Future<void> updateDistance(double value) async {
    await _reference.get().then((snapshot) {
      if (snapshot.exists) {
        CurrentStatusModel model = CurrentStatusModel.fromMap(snapshot.data());
        double distance = model.distance ?? 0;
        distance = distance * 100000; // km to cm
        distance = distance + value;
        distance = distance / 100000;
        _reference.update({'distance': distance});
      }
    });
  }

  @override
  Future<void> updateUserHW(double height, double weight) async {
    if (height == null || weight == null) {
      return null;
    }

    await _reference.update({
      'weight': weight.toDouble(),
      'height': height.toDouble(),
    });
    print('Update Weight and Height complete');
  }

  @override
  Future<DocumentReference> getPlanRef() async {
    final CurrentStatusModel currentStatusModel =
        await this.fetchCurrentStatus();

    if (currentStatusModel.planRef == null) {
      print('planRef currently on null');
      return null;
    } else {
      return currentStatusModel.planRef;
    }
  }
}
