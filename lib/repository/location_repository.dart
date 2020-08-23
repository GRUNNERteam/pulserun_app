import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class LocationRepository {
  Future<LocationModel> uploadToDB(
      int planId, String runId, LocationModel data);
}

class LocationDB implements LocationRepository {
  @override
  Future<LocationModel> uploadToDB(
      int planId, String runId, LocationModel data) {
    LocationModel _data = data;
    DocumentReference _ref = DatabaseService()
        .getUserRef()
        .collection('plan')
        .doc(planId.toString())
        .collection('run')
        .doc(runId);
    ;
  }
}
