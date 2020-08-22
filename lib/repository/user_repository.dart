import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/services/database/database.dart';

abstract class UserRepository {
  Future<UserModel> fetchUser();
}

class UserDB implements UserRepository {
  @override
  Future<UserModel> fetchUser() async {
    DocumentReference _ref = DatabaseService().getUserRef();
    UserModel data;
    await _ref.get().then((snapshot) {
      if (snapshot.exists) {
        data = UserModel.fromMap(snapshot.data());
      } else {
        // Create User
        print('Create User');
        var currentUser = FirebaseAuth.instance.currentUser;
        _ref.set(UserModel(currentUser.uid, currentUser.displayName,
                currentUser.photoURL, currentUser.email, null)
            .toMap());
        data = UserModel(currentUser.uid, currentUser.displayName,
            currentUser.photoURL, currentUser.email, null);
      }
    });
    return data;
  }
}
