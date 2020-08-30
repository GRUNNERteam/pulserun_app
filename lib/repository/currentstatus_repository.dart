import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class CurrentStatusRepository {
  Future<CurrentStatusModel> fetchCurrentStatus();

  Future<double> fetchDistanceToCurrentStatus();

  Future<void> updateDistance(double value);
}

class CurrentStatus implements CurrentStatusRepository {
  DocumentReference _reference =
      DatabaseService().getUserRef().collection('stat').doc('current');

  @override
  Future<CurrentStatusModel> fetchCurrentStatus() async {
    CurrentStatusModel data;

    await _reference.get().then((snapshot) {
      if (snapshot.exists) {
        // snapshot.data().forEach((key, value) {
        //   var type = value.runtimeType;
        //   print('$key : $type');
        // });
        data = CurrentStatusModel.fromMap(snapshot.data());

        print(data.toString());
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
}
