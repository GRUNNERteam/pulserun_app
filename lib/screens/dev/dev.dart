import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/screens/auth/auth.dart';
import 'package:pulserun_app/screens/home/home.dart';
import 'package:pulserun_app/screens/login/login.dart';
import 'package:pulserun_app/screens/map/map.dart';
import 'package:pulserun_app/screens/register/register.dart';
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
                child: Text('HomePage'),
                onPressed: () {
                  return null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              RaisedButton(
                child: Text('LoginPage'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text('RegisterPage'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text('MapPage'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(),
                    ),
                  );
                },
              ),
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
