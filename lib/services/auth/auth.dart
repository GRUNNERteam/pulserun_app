import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/models/user.dart';

class AuthService {

  // Data is store in Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign In with Email and Password
  Future signInWithEmailAndPassword(email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(result);
      return user;

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with Email and Password
  Future registerWithEmailAndPassword(email, password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(result);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOutInstance() async{
    try{
      // no need to return a result from firebase
      // just sign out Instance
      await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
