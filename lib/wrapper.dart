import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/user_repository.dart';
import 'package:pulserun_app/screens/auth/auth.dart';
import 'package:pulserun_app/screens/home/home.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _initialized = false;
  bool _error = false;
  User _user = FirebaseAuth.instance.currentUser;
  bool _isSignIn = false;
  @override
  void initState() {
    initialize();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    super.initState();
  }

  void initialize() async {
    try {
      bool isEmpty = await FirebaseAuth.instance.userChanges().isEmpty;
      setState(() {
        _isSignIn = (isEmpty) ? false : true;
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Wrapper Created');
    // Show error message if initialization failed
    if (_error) {
      return ShowErrorWidget();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return LoadingWidget();
    }

    print(FirebaseAuth.instance.currentUser);
    print(_user);
    if (_user == null) {
      return AuthPage();
    } else {
      return BlocProvider(
        create: (context) => HomeCubit(UserDB(), CurrentStatus()),
        child: HomePage(),
      );
    }
  }
}
