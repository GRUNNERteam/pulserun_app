import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class LocationRepository {
  Future<LocationModel> uploadToDB(int planId, LocationModel data);
}

class TestLocationDB implements LocationRepository {
  @override
  Future<LocationModel> uploadToDB(int planId, LocationModel data) async {
    LocationModel _data;
    DocumentReference _ref = DatabaseService()
        .getUserRef()
        .collection('plan')
        .doc(planId.toString())
        .collection('run')
        .doc();
    ;

    await _ref.set(data.toMap());

    return _data;
  }
}
