import 'package:flutter/material.dart';
import 'package:pulserun_app/models/plan.dart';

class PlanDetailsBody extends StatelessWidget {
  final PlanModel planModel;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PlanDetailsBody({Key key, this.planModel, this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Plan Details'),
                  Row(
                    children: <Widget>[
                      Text('planId'),
                      Text(planModel.planId),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Type'),
                      Text(planModel.goal.planType
                          .enumToString(planModel.goal.planType))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Goal'),
                      Text(planModel.goal.goal),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Start Date'),
                      Text(planModel.start.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
