import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // ignore: unused_field
  UserModel _user;
  // firestore
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  DatabaseService(User value) {
    this._user = new UserModel(value);
    this.createAccount(value);
  }
  //for register first time
  Future<void> createAccount(User user) async {
    print("Createing User in Database ...");
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var userRef = _firestoreInstance.collection("users").doc(firebaseUser.uid);

    userRef.get().then(
          (docSnapshot) => {
            if (!docSnapshot.exists)
              {
                userRef
                    .set(UserModel(user).getAllUserData())
                    .then((_) => print("INIT DATA ACCOUNT COMPLETED!!"))
              }
            else
              {print("User already existing")}
          },
        );
  }
}
