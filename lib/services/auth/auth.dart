import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulserun_app/models/user.dart';

class AuthService {
  // Data is store in Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Check for have user in app or not
  // by using stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // UserModel _userFromFirebase(UserCredential result) {
  //   return user != null
  //       ? UserModel(
  //           uid: result.user.uid,
  //           displayName: result.user.displayName,
  //           imageURL: result.user.photoURL,
  //         )
  //       : null;
  // }

  // Sign In with Email and Password
  // Future signInWithEmailAndPassword(email, password) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //         email: email.trim(), password: password);
  //     return _userFromFirebase(result);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // // Register with Email and Password
  // Future registerWithEmailAndPassword(email, password) async {
  //   try {
  //     UserCredential result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return _userFromFirebase(result);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // Sign Out
  Future signOutInstance() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential> signInWithGoogleAccount() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
