// import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/wrapper.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // bypass for dev

    // return Wrapper();
    // .flr is from rive.app
    // I will re-desgin the splash-screen after got a name of application
    // return SplashScreen.navigate(
    //   name: 'assets/splash.flr',
    //   next: (_) => Wrapper(),
    //   until: () => Future.delayed(Duration(seconds: 3)),
    //   startAnimation: 'Splash',
    // );
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new Wrapper(),
      title: new Text('Welcome to FatDash'),
      image: new Image.asset('assets/FAT_DASH_SPLASH.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 72,
      ),
      loadingText:
          new Text("Exercise Planning and Tracking Management Systems"),
      photoSize: 100.0,
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}
