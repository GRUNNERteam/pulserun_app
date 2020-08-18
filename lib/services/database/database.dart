import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/models/user.dart';

class DatabaseService {
  // firestore
  final _firestoreInstance = Firestore.instance;
  DatabaseService() {}
  //for register first time
  Future<void> createAccount(UserModel user) async {
    print("Createing User in Database ...");
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var userRef =
        _firestoreInstance.collection("users").document(firebaseUser.uid);

    userRef.get().then(
          (docSnapshot) => {
            if (!docSnapshot.exists)
              {
                userRef
                    .setData(user.getAllUserData())
                    .then((_) => print("INIT DATA ACCOUNT COMPLETED!!"))
              }
            else
              {print("User already existing")}
          },
        );
  }
}
