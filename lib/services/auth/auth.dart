import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In with Email and Password
  Future signInWithEmailAndPassword(email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
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
      FirebaseUser user = result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
