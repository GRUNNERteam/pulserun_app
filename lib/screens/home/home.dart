import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/models/user.dart';
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
    final userData = Provider.of<UserModel>(context);
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
      drawer: Drawer(
        semanticLabel: 'test',
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget>[
            DrawerHeader(
              
              child: Text('MENU'),
              decoration: BoxDecoration(),
            ),
          ]
        )
      ),
      body: Center(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              // if did not use ${} instead of directly from provider. it will cause invalid argument(by Provider found null data)
              child: Text('Hello, ${userData.displayName}'),
            ),
            SizedBox(height: 10.0),
            Container(
              height:180.0,
              child:
              // should replace with firebase user image
              // await ref.getDownloadURL();
              // not done yet
              Image.network('https://www.pngfind.com/pngs/m/535-5357481_user-account-management-circle-user-icon-blue-hd.png')
            )
        //Text('USER : ' + widget.name),
        // Text('Home Screen'),
        // Text('Todo List'),
        // Container(
        //     height: 60,
        //     padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //     child: RaisedButton(
        //       textColor: Colors.white,
        //       color: Colors.blue,
        //       child: Text('Sign Out'),
        //       // onPressed: () =>  signout(context)
        //       onPressed: () {
        //         _auth.signOutInstance();
        //       },
        //     )),
        // Container(
        //     height: 60,
        //     padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //     child: RaisedButton(
        //       textColor: Colors.white,
        //       color: Colors.blue,
        //       child: Text('Heart rate'),
        //       //onPressed: () =>  Navigator.push(context,MaterialPageRoute(builder: (context) => myH()))
        //       onPressed: () {},
        //     )),
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
