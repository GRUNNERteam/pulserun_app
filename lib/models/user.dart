import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String uid;
  // Constructor
  UserModel(AuthResult result){
    this.uid = result.user.uid;
  }

  String getUid(){
    return uid.toString();
  }
}