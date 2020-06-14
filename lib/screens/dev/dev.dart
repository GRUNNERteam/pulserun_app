import 'package:flutter/material.dart';
import 'package:pulserun_app/screens/login/login.dart';
import '../home/home.dart';

class DevPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Loading DevPage!!!');
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('DevPage')),
        body: Center(
            widthFactor: MediaQuery.of(context).size.width,
            child: Container(
                child: Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('HomePage'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  title: 'HomePage',
                                )));
                  },
                ),
                RaisedButton(
                  child: Text('LoginPage'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ))));
  }
}