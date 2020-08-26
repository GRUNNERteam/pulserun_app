import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:pulserun_app/theme/theme.dart';

// https://github.com/afgprogrammer/Flutter-Login-Page-3/tree/master/lib

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = true;

  final _authService = AuthService();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialize() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        // await _authService.signOutInstance();
        // setState(() {
        //   print('Sign Out Instance Complete!');
        //   _isLoading = false;
        // });

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final _signInvalidation = Provider.of<ValidationLogin>(context);
    if (_isLoading) {
      return LoadingWidget();
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                GlobalTheme.tiffany_blue,
                GlobalTheme.light_cyan,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        color: GlobalTheme.white,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Wellcome back to FatDash!",
                      style: TextStyle(
                        color: GlobalTheme.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: GlobalTheme.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'To Sign In, ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'You need google account'),
                                ]),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 1,
                            width: 300,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  // Google PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null)
                                  // https://stackoverflow.com/questions/47619229/google-sign-in-failed-com-google-android-gms-common-api-apiexception-10
                                  // SHA1  key error
                                  child: GoogleSignInButton(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    borderRadius: 20,
                                    darkMode: false,
                                    onPressed: () {
                                      return FutureBuilder(
                                        future: _authService
                                            .signInWithGoogleAccount(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 150,
                          ),
                          Container(
                            child: TypewriterAnimatedTextKit(
                              speed: Duration(milliseconds: 300),
                              text: [
                                'Stay fit with us',
                                'Fat Dash',
                              ],
                              textStyle: TextStyle(
                                fontSize: 36,
                              ),
                              repeatForever: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}
