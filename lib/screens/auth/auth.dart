import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:pulserun_app/theme/theme.dart';
import 'package:pulserun_app/validation/validation_login.dart';

// https://github.com/afgprogrammer/Flutter-Login-Page-3/tree/master/lib

class AuthPageState extends State<AuthPage> {
  bool _isLoading = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _usernameController.clear();
    _passwordController.clear();
    _isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _passwordController.dispose();
    _isLoading = true;
    super.dispose();
  }

  Widget _tab(String name) {
    return Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(name),
      ),
    );
  }

  Widget _signIn(BuildContext context) {
    return LoadingWidget();
  }

  Widget _signUp(BuildContext context) {
    return LoadingWidget();
  }

  @override
  Widget build(BuildContext context) {
    final _signInvalidation = Provider.of<ValidationLogin>(context);

    return Scaffold(
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
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: GlobalTheme.white,
                            boxShadow: [
                              BoxShadow(
                                color: GlobalTheme.light_cyan_shadow,
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    errorText: _signInvalidation.username.error,
                                    hintText: "Enter an Email",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String value) =>
                                      _signInvalidation.changeUsername(value),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    errorText: _signInvalidation.password.error,
                                    hintText: "Enter an Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String value) =>
                                      _signInvalidation.changePassword(value),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ButtonTheme(
                          minWidth: double.infinity,
                          height: 50.0,
                          disabledColor: GlobalTheme.default_error,
                          buttonColor: GlobalTheme.tiffany_blue,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: (!_signInvalidation.isValid)
                                ? null
                                : _signInvalidation.submit,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Continue with other way",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
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
                                  darkMode: false,
                                  onPressed: () => _authService
                                      .signInWithGoogleAccount(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => AuthPageState();
}
