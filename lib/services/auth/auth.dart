import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Future signOutInstance() async {
    try {
      // no need to return a result from firebase
      // just sign out Instance
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogleAccount(BuildContext context) async {
    // Gain Access to google login before put user into firebase auth
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    // Put user into firebase auth
    try {
      AuthResult result = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: userAuth.idToken, accessToken: userAuth.accessToken));
      // TODO: return uid to current context/screens
      UserModel user = UserModel(result);
      return user; // return only needed infomation

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
