import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/screens/splash/splash.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:pulserun_app/theme/theme.dart';
import 'package:pulserun_app/validation/validation_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set Device to portraitUp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ValidationLogin(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // for aualytics project
  // via firebase console
  // ignore: todo
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: ShowErrorWidget(),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: "FatDash",
            theme: GlobalTheme.mytheme,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: SplashPage(),
          );
        }
        return MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        );
      },
    );
  }
}
