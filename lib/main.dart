import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/bloc/running_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/heartrate_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/result_repository.dart';
import 'package:pulserun_app/repository/running_repository.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:pulserun_app/screens/splash/splash.dart';
import 'package:pulserun_app/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set Device to portraitUp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit(UserDB(), CurrentStatus())),
        BlocProvider(
            create: (context) => RunningBloc(
                  Location(),
                  RunningData(),
                  PlanData(),
                  CurrentStatus(),
                  TestHeartRate(),
                  UserDB(),
                  Result(),
                )),
        BlocProvider(
          create: (context) => PlanBloc(PlanData(), CurrentStatus()),
        )
      ],
      child: FutureBuilder(
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
      ),
    );
  }
}
