import 'package:flutter/material.dart';
import 'package:pulserun_app/components/widgets/button_widget.dart';
import 'package:pulserun_app/components/widgets/textfield_widget.dart';
import 'package:pulserun_app/components/widgets/wave_widget.dart';
import 'package:pulserun_app/theme/theme.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height - 200,
            color: GlobalTheme.white,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
                size: size,
                yOffset: size.height / 3.0,
                color: GlobalTheme.mediumBlue),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextFieldWidget(
                  hintText: 'Email',
                  obscureText: false,
                  prefixIconData: Icons.mail_outline,
                  // suffixIconData: model.isValid ? Icons.check : null,
                  suffixIconData: null,
                  onChanged: (value) {
                    //model.isValidEmail(value);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextFieldWidget(
                      hintText: 'Password',
                      //obscureText: model.isVisible ? false : true,
                      obscureText: true,
                      prefixIconData: Icons.lock_outline,
                      //suffixIconData: model.isVisible ? Icons.visibility : Icons.visibility_off,
                      suffixIconData: Icons.visibility_off,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: GlobalTheme.mediumBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                ButtonWidget(
                  title: 'Login',
                  hasBorder: false,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ButtonWidget(
                  title: 'Sign Up',
                  hasBorder: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
