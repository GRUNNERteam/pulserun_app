import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class CurrentStatusRepository {
  Future<CurrentStatusModel> fetchCurrentStatus();
}

class CurrentStatus implements CurrentStatusRepository {
  @override
  Future<CurrentStatusModel> fetchCurrentStatus() async {
    DocumentReference _ref =
        DatabaseService().getUserRef().collection('stat').doc('current');
    CurrentStatusModel data;
    await _ref.get().then((snapshot) {
      if (snapshot.exists) {
        // snapshot.data().forEach((key, value) {
        //   var type = value.runtimeType;
        //   print('$key : $type');
        // });
        data = CurrentStatusModel.fromMap(snapshot.data());

        print(data.toString());
      } else {
        // init value
        _ref.set(
            CurrentStatusModel(bmi: 0, status: 'UNKOWNS', distance: 0).toMap());
        data = CurrentStatusModel(bmi: 0, status: 'UNKOWNS', distance: 0);
      }
    });
    return data;
  }
}
