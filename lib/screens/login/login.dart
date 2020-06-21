import 'package:flutter/material.dart';
// import 'package:pulserun_app/screens/GoogleLogin/googlelogin.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulserun_app/screens/home/home.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulserun_app/screens/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Loading Login Page');
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Pulse Run',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                    //not this time
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        print(nameController.text);
                        print(passwordController.text);
                      },
                    )),
                    Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Google Account'),
                      onPressed: () =>  signinWithGoogle(context)
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Does not have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}

 Future signinWithGoogle(BuildContext context) async {
   final GoogleSignIn googleSignIn = GoogleSignIn( scopes: [
        'https://www.googleapis.com/auth/fitness.body.read',
      ],);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage(name: user.displayName)));
   }