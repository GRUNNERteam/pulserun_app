import 'package:flutter/material.dart';
import 'package:pulserun_app/services/auth/auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfirmController = TextEditingController();
  bool _eula = false;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();

  bool _validateRegister() {
    // For validate the data it should vaildate from firebase
    // Simple check for not set any empty to backend
    if (_eula == false) {
      print('eula false');
      _scaffoldstate.currentState.showSnackBar(new SnackBar(
          content: new Text('You not agree Terms and Conditions'),
          duration: new Duration(seconds: 5),
          backgroundColor: Colors.red));
      return false;
    }
    if (nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordconfirmController.text.isEmpty) {
      print('empty controller');
      _scaffoldstate.currentState.showSnackBar(new SnackBar(
          content:
              new Text('Please complete the require infomation to register'),
          duration: new Duration(seconds: 5),
          backgroundColor: Colors.red));
      return false;
    }

    if (passwordController.text != passwordconfirmController.text) {
      print('password not match');
      _scaffoldstate.currentState.showSnackBar(new SnackBar(
          content: new Text('Please re-type password again.'),
          duration: new Duration(seconds: 5),
          backgroundColor: Colors.red));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('Loading Register Page');
    return Scaffold(
        key: _scaffoldstate,
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
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        hintText: 'E-mail address only.'),
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
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordconfirmController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Re-type password again',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: _eula,
                        onChanged: (bool value) {
                          // this will impact the perfomance
                          // because is re-rendering the whole page
                          // TO-FIX : use Provider
                          setState(() {
                            _eula = value;
                          });
                        },
                      ),
                      Text('I Agree to Terms and Conditions'), // not write yet
                    ],
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Register'),
                      onPressed: () async {
                        if (_validateRegister()) {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  nameController.text, passwordController.text);
                          if(result != null){
                            print(result);
                            Navigator.pop(context);
                          }else{
                            print(result);
                          }
                        }
                      },
                    )),
              ],
            )));
  }
}
