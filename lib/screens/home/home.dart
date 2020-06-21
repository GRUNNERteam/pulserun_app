import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulserun_app/screens/dev/dev.dart';

class HomePage extends StatefulWidget {
  
  HomePage({Key key, this.name}) : super(key: key);
  final String name;
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('HOME')),
      body: Center(child: Column(
        children: <Widget>[
          Text('USER : ' + widget.name),
          Text('Home Screen'),
          Text('Todo List'),
           Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Sign Out'),
                      onPressed: () =>  signout(context)
                    )),
        ]
      )),
    );
  }
}

 Future signout(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    bool isSigned = await googleSignIn.isSignedIn();
    if(isSigned){
      await googleSignIn.signOut();
      Navigator.push(context,MaterialPageRoute(builder: (context) => DevPage()));
    }
   }