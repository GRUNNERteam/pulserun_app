import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulserun_app/models/user.dart';

class AuthService {
  // Data is store in Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  // Check for have user in app or not
  // by using stream
  Stream<UserModel> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  UserModel _userFromFirebase(FirebaseUser user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            displayName: user.displayName,
            imageURL: user.photoUrl,
          )
        : null;
  }

  // Sign In with Email and Password
  Future signInWithEmailAndPassword(email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return _userFromFirebase(result.user);
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
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOutInstance() async {
    try {
      bool isGoogleSignIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignIn) {
        await _googleSignIn.signOut();
      }

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogleAccount(BuildContext context) async {
    // Gain Access to google login before put user into firebase auth

    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    // Put user into firebase auth
    try {
      AuthResult result = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: userAuth.idToken, accessToken: userAuth.accessToken));
      return _userFromFirebase(result.user); // return only needed infomation

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
