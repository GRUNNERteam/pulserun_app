import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DocumentReference _userRef;
  // firestore
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  DatabaseService() {
    print('Construct DB Service..');
    this._userRef = _firestoreInstance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid);
  }

  DocumentReference getUserRef() {
    return this._userRef;
  }
}
