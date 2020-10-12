import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
import 'package:pulserun_app/screens/plan/plan.dart';

class BottomCardWidget extends StatelessWidget {
  const BottomCardWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Text(
          'Create Plan'.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PlanPage()));
        });
  }
}
