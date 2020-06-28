import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/screens/home/home.dart';
import 'package:pulserun_app/screens/login/login.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    print(user.toString());
    if (user == null) {
      return LoginPage();
    } else {
      return HomePage(name: 'Pules App');
    }
  }
}
