import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  // Constructor
  UserModel({this.uid});
  String getUid() {
    return this.isEmpty() ? null : this.uid.toString();
  }

  bool isEmpty() {
    if (this.uid == null) {
      return true;
    }
    return false;
  }
}
