import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class PlanRepository {
  Future<PlanModel> fetchPlan();
  Future<List<PlanModel>> fetchPlanLists();
  Future<DocumentReference> getRef();

  Future<void> setRef();

  Future<void> createPlan(PlanModel plan);
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

        // data = PlanModel(
        //     planId: planid, targetHeartRate: 180, start: DateTime.now());

        _ref.set(data.toMap());
      }
    });

    return data;
  }

  @override
  Future<DocumentReference> getRef() async {
    return this._reference;
  }

  @override
  Future<void> createPlan(PlanModel plan) {
    // TODO: implement createPlan
    throw UnimplementedError();
  }

  @override
  Future<void> setRef() {
    // TODO: implement setRef
    throw UnimplementedError();
  }

  @override
  Future<List<PlanModel>> fetchPlanLists() {
    // TODO: implement fetchPlanLists
    throw UnimplementedError();
  }
}

class PlanData implements PlanRepository {
  DocumentReference _reference;
  @override
  Future<PlanModel> fetchPlan() async {
    await this.setRef();
    PlanModel plan;

    await _reference.get().then((snapShot) {
      if (snapShot.exists) {
        plan = PlanModel.fromMap(snapShot.data());
      }
    });

    return plan;
  }

  @override
  Future<DocumentReference> getRef() async {
    return this._reference;
  }

  @override
  Future<void> setRef() async {
    await DatabaseService()
        .getUserRef()
        .collection('stat')
        .doc('current')
        .get()
        .then((snapShot) {
      if (snapShot.data().isNotEmpty) {
        this._reference = snapShot.data()['planRef'];
      }
    });
  }

  @override
  Future<void> createPlan(PlanModel plan) async {
    DocumentReference planRef =
        DatabaseService().getUserRef().collection('plan').doc();
    DateTime dob;
    // Check before create
    try {
      await DatabaseService().getUserRef().get().then((snapShot) {
        if (!snapShot.exists || snapShot.data()['birthDate'] == null) {
          throw Exception('User or BirthDate not Exists');
        }
        dob = DateTime.parse(snapShot.data()['birthDate']);
      });
      print(plan.goal.toString());
      await planRef.set(
        plan.toMap(),
      );

      print('Updating planRef');

      await DatabaseService()
          .getUserRef()
          .collection('stat')
          .doc('current')
          .update({'planRef': planRef});

      print('Updating Normal target heartRate');

      double thr = (220 - Jiffy(DateTime.now()).diff(dob, Units.YEAR)) * 0.5;

      await planRef.update({
        'planId': planRef.id,
        'targetHeartRate': thr.toInt(),
      });

      print('Creating Plan successful');
    } catch (e) {
      print('Creating Plan failed : $e');
    }
  }

  @override
  Future<List<PlanModel>> fetchPlanLists() async {
    List<PlanModel> planList = List<PlanModel>();
    await DatabaseService()
        .getUserRef()
        .collection('plan')
        .get()
        .then((snapShotCollection) {
      if (snapShotCollection.size > 0) {
        snapShotCollection.docs.forEach((doc) {
          if (doc.exists && doc.data().isNotEmpty) {
            print(doc.data()['planId']);
            planList.add(PlanModel.fromMap(doc.data()));
          }
        });
      }
    });
    return planList;
  }
}
