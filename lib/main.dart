import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/screens/dev/dev.dart';

void main() {
  // Set Device to portraitUp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // for aualytics project
  // via firebase console
  // TODO : implement observe in each page
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics:analytics);


  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseApp',
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.cyanAccent,
        fontFamily: 'Open Sans',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
      ),
      darkTheme: ThemeData(
          // For supported Dark Mode
          brightness: Brightness.dark),
      home: DevPage(),
    );
  }
}
