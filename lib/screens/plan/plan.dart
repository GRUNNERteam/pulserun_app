import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/screens/plan/components/plan_create_body.dart';
import 'package:pulserun_app/screens/plan/components/plan_loaded_body.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        print(state.toString());
        if (state is PlanInitial) {
          BlocProvider.of<PlanBloc>(context).add(GetPlan());
          return LoadingWidget();
        } else if (state is PlanLoading) {
          return LoadingWidget();
        } else if (state is PlanLoaded) {
          return Scaffold(
            key: _scaffoldKey,
            body: PlanLoadedBody(),
          );
        } else if (state is PlanCreate) {
          return Scaffold(
            key: _scaffoldKey,
            body: PlanCreateBody(
              scaffoldKey: _scaffoldKey,
            ),
          );
        } else {
          // Show error page
          return ShowErrorWidget();
        }
      },
    );
  }
}
