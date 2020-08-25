import 'package:flutter/material.dart';
import 'package:pulserun_app/screens/auth/auth.dart';
import 'package:pulserun_app/screens/home/home.dart';
import 'package:pulserun_app/services/auth/auth.dart';

class DevPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    print('Loading DevPage!!!');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DevPage',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
      ),
      body: Center(
        widthFactor: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("AuthPage"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new AuthPage(),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text("SignOut"),
                onPressed: () async => await _auth.signOutInstance(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
