import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  String displayName;
  String photoURL;
  String email;

  Map<String, dynamic> statistic = {};
  // Constructor
  UserModel(User user) {
    this.uid = user.uid;
    this.displayName = user.displayName;
    this.photoURL = user.photoURL;
    this.email = user.email;
  }
  String getUid() {
    return this.isEmpty() ? null : this.uid.toString();
  }

  bool isEmpty() {
    if (this.uid == null) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> getAllUserData() {
    return {
      'uid': this.uid,
      'email': this.email,
      'displayName': this.displayName,
      'photoURL': this.photoURL,
      'statistic': this.statistic,
    };
  }
}
