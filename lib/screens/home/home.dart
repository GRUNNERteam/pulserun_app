import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulserun_app/screens/dev/dev.dart';
import 'package:pulserun_app/services/auth/auth.dart';
//import 'package:pulserun_app/screens/health/health.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.name}) : super(key: key);
  final String name;

  @override
  _HomePageState createState() => _HomePageState();
}

// for popupmenu
enum choice { sign_out }

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  void choiceAction(choice c) {
    switch (c) {
      case choice.sign_out:
        {
          _auth.signOutInstance();
          break;
        }
      default:
        {
          print('choiceAction : out of scope');
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton<choice>(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<choice>>[
                    const PopupMenuItem<choice>(
                        value: choice.sign_out, child: Text('sign out'))
                  ]
              // padding: EdgeInsets.only(right: 20),
              // child: Icon(Icons.account_circle),
              )
        ],
        centerTitle: true,
      ),
      body: Center(
          child: Column(children: <Widget>[
        //Text('USER : ' + widget.name),
        Text('Home Screen'),
        Text('Todo List'),
        Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Sign Out'),
              // onPressed: () =>  signout(context)
              onPressed: () {
                _auth.signOutInstance();
              },
            )),
        Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Heart rate'),
              //onPressed: () =>  Navigator.push(context,MaterialPageRoute(builder: (context) => myH()))
              onPressed: () {},
            )),
      ])),
    );
  }
}

//  Future signout(BuildContext context) async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     bool isSigned = await googleSignIn.isSignedIn();
//     if(isSigned){
//       await googleSignIn.signOut();
//       Navigator.push(context,MaterialPageRoute(builder: (context) => DevPage()));
//     }
//    }
