import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class PlanRepository {
  Future<PlanModel> fetchPlan();
  Future<DocumentReference> getRef();
}

class MockUpPlan implements PlanRepository {
  final DocumentReference _reference =
      DatabaseService().getUserRef().collection('plan').doc('0');
  @override
  Future<PlanModel> fetchPlan() async {
    // ref doc zero for mockup plan

    int planid = 0;
    DocumentReference _ref = DatabaseService()
        .getUserRef()
        .collection('plan')
        .doc(planid.toString());

    PlanModel data;

    await _ref.get().then((snapshot) async {
      if (snapshot.exists) {
        data = PlanModel.fromMap(snapshot.data());
      } else {
        UserRepository userRepository = UserDB();
        UserModel userModel = await userRepository.fetchUser();

        // Createing Plan
        data = PlanModel(
            planId: planid,
            targetHeartRate: userModel.targetHeartrate,
            start: DateTime.now());

        _ref.set(data.toMap());
      }
    });

    return data;
  }

  @override
  Future<DocumentReference> getRef() async {
    return this._reference;
  }
}
