import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/models/plan.dart';

class EditTitlePlanDialog extends StatefulWidget {
  final PlanModel planModel;
  const EditTitlePlanDialog({Key key, this.planModel}) : super(key: key);

  @override
  _EditTitlePlanDialogState createState() => _EditTitlePlanDialogState();
}

class _EditTitlePlanDialogState extends State<EditTitlePlanDialog> {
  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Title Edit'),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: 'Title',
          hintText: 'Please type name of title',
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Confirm'),
          onPressed: () {
            widget.planModel.name = _textEditingController.value.text;
            BlocProvider.of<PlanBloc>(context)
                .add(UpdatePlan(planModel: widget.planModel));

            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
