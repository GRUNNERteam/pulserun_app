import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/screens/plan/components/planlist_item.dart';

class PlanLoadedBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<PlanModel> listPlan;

  const PlanLoadedBody({Key key, this.scaffoldKey, this.listPlan})
      : super(key: key);

  @override
  _PlanLoadedBodyState createState() => _PlanLoadedBodyState();
}

class _PlanLoadedBodyState extends State<PlanLoadedBody> {
  final SlidableController slidableController = SlidableController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.listPlan.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Colors.white,
              child: PlanListItem(
                name: widget.listPlan[index].planId,
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () {},
              ),
              IconSlideAction(
                caption: 'Share',
                color: Colors.indigo,
                icon: Icons.share,
                onTap: () {},
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'More',
                color: Colors.black45,
                icon: Icons.more_horiz,
                onTap: () {},
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {},
              ),
            ],
          );
        });
  }
}
