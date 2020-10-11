import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class UserRepository {
  Future<UserModel> fetchUser();
  Future<void> updateUserDoB(DateTime dob);
}

class UserDB implements UserRepository {
  final DocumentReference _ref = DatabaseService().getUserRef();
  @override
  Future<UserModel> fetchUser() async {
    UserModel data;
    await _ref.get().then((snapshot) {
      if (snapshot.exists) {
        data = UserModel.fromMap(snapshot.data());
      } else {
        // Create User
        print('Create User');
        var currentUser = FirebaseAuth.instance.currentUser;
        _ref.set(UserModel(currentUser.uid, currentUser.displayName,
                currentUser.photoURL, currentUser.email, null, null)
            .toMap());
        data = UserModel(currentUser.uid, currentUser.displayName,
            currentUser.photoURL, currentUser.email, null, null);
      }
    });

    // cleanup false data

    await _ref
        .collection('plan')
        .doc('0')
        .collection('run')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.docs.isNotEmpty) {
        docSnapshot.docs.forEach((QueryDocumentSnapshot doc) {
          doc.reference.collection('location').get().then((snapshot) {
            if (snapshot.docs.isEmpty) {
              doc.reference.delete();
            }
          });
        });
      }
    });

    return data;
  }

  @override
  Future<void> updateUserDoB(DateTime dob) async {
    if (dob == null) {
      return null;
    }
    int targetHR = 220 - (DateTime.now().year - dob.year);
    await _ref.update({
      'birthDate': dob.toString(),
    });
    await _ref.update({
      'targetHeartrate': targetHR,
    });
    print('Update DoB complete');
  }
}
