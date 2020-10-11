import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
import 'package:pulserun_app/screens/plan/plan.dart';

class BottomCardWidget extends StatelessWidget {
  const BottomCardWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text('Createing Plan'),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PlanPage()));
          BlocProvider.of<HomeCubit>(context).emptyPlan();
        });
  }
}
