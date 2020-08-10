import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/models/user.dart';

class DatabaseService {
  // firestore
  final _firestoreInstance = Firestore.instance;

  DatabaseService(UserModel user) {
    _createAccount(user);
  }
  //for register first time
  Future<void> _createAccount(UserModel user) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var userRef =
        _firestoreInstance.collection("users").document(firebaseUser.uid);

    userRef.get().then((docSnapshot) => {
          if (!docSnapshot.exists)
            {
              userRef
                  .setData(user.getAllUserData())
                  .then((_) => print("INIT DATA ACCOUNT COMPLETED!!"))
            }
        });
  }
}
