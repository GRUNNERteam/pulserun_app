import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  UserModel _user = new UserModel();
  DocumentReference _userRef;
  // firestore
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  DatabaseService() {
    print('Construct DB Service..');
    this._user.setUserModel(FirebaseAuth.instance.currentUser);
    this._userRef = _firestoreInstance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid);
    this.createAccount();
  }

  DocumentReference getUserRef() {
    return this._userRef;
  }

  UserModel getUserModel() {
    return this._user;
  }

  //for register first time
  Future<void> createAccount() async {
    print("Createing User in Database ...");
    _userRef.get().then(
          (docSnapshot) => {
            if (!docSnapshot.exists)
              {
                _userRef.set(_user.getAllUserData()).then(
                  (_) {
                    print("INIT DATA ACCOUNT COMPLETED!!");
                  },
                )
              }
            else
              {
                print("User already existing"),
                _userRef.update(_user.getAllUserData()).then((_) {
                  print('Updateing User db from User Model ...');
                  getUserData();
                })
              }
          },
        );
  }

  Future<UserModel> getUserData() async {
    print('Getting User Data from firestore');
    DocumentSnapshot snapshot = await _userRef.get();
    if (snapshot.data().isNotEmpty) {
      Map<String, dynamic> data = snapshot.data();
      // debugging
      // data.forEach((key, value) {
      //   print('${key} : ${value}');
      // });

      this._user.setAllData(data);
      return this._user;
    } else {
      return null;
    }
  }
}
