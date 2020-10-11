import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/screens/plan/components/plan_detail.dart';
import 'package:pulserun_app/screens/plan/components/plan_edit_title.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel planModel;
  const PlanListItem({Key key, this.planModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(planModel.name ?? 'Untitled'),
      subtitle: Text(planModel.start.toString()),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(planModel.name ?? 'Untitled'),
              ),
              body: PlanDetailsBody(
                planModel: planModel,
              ),
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditTitlePlanDialog(
                planModel: planModel,
              );
            });
      },
    );
  }
}
