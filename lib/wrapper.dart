import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/screens/auth/auth.dart';
import 'package:pulserun_app/screens/dev/dev.dart';
import 'package:pulserun_app/screens/home/home.dart';
import 'package:pulserun_app/screens/login/login.dart';
import 'package:pulserun_app/services/auth/auth.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // bypass by login with dev account
    // final AuthService _auth = AuthService();
    // _auth.signInWithEmailAndPassword(
    //     'devacc@dev.com', '123456789'); // will remove for production build
    // end

    final _user = Provider.of<UserModel>(context);

    print(_user);

    if (_user == null) {
      return AuthPage();
    } else {
      return DevPage();
      //return HomePage(name: 'Pules App');
    }
  }
}
