import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
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

  RaisedButton _button(BuildContext context) {
    return RaisedButton(
      child: Text('Create Plan'),
      onPressed: () {
        BlocProvider.of<PlanBloc>(context).add(PlanCreatingTrigger());
      },
    );
  }

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
                  planModel: widget.listPlan[index],
                )),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Info',
                color: Colors.blue,
                icon: MdiIcons.information,
                onTap: () {},
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: MdiIcons.delete,
                onTap: () {
                  BlocProvider.of<PlanBloc>(context).add(
                    DeletePlan(planId: widget.listPlan[index].planId),
                  );

                  BlocProvider.of<HomeCubit>(context).getUser();
                },
              ),
            ],
          );
        });
  }
}
