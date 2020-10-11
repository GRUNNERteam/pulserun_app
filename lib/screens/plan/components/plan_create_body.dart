import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/models/plan.dart';

class PlanCreateBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PlanCreateBody({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _PlanCreateBodyState createState() => _PlanCreateBodyState();
}

class _PlanCreateBodyState extends State<PlanCreateBody> {
  final _formKeyCreatePlan = GlobalKey<FormState>();
  int _planType = 0;
  List<DropdownMenuItem<int>> _planTypeLists = [];

  TextEditingController _goalTextController;
  TextEditingController _breakDayTextController;
  InputDecoration loadDecoration() {
    if (_planType == 0) {
      return InputDecoration(
        labelText: 'Set goal with distance',
        icon: Icon(MdiIcons.run),
        hintText: 'Kilometer',
      );
    }
    if (_planType == 1) {
      return InputDecoration(
        labelText: 'Set goal with step-counts',
        icon: Icon(MdiIcons.shoePrint),
        hintText: 'Step Count',
      );
    }
    if (_planType == 2) {
      return InputDecoration(
        labelText: 'Set goal with average heart-rate',
        icon: Icon(MdiIcons.heart),
        hintText: 'BPM (should less than 220)',
      );
    }
    return InputDecoration();
  }

  void loadplanTypeLists() {
    _planTypeLists = [];

    _planTypeLists.add(
      new DropdownMenuItem(
        child: new Text('Distance'),
        value: 0,
      ),
    );
    _planTypeLists.add(
      new DropdownMenuItem(
        child: new Text('Step'),
        value: 1,
      ),
    );
    _planTypeLists.add(
      new DropdownMenuItem(
        child: new Text('Target Heart Rate'),
        value: 2,
      ),
    );
  }

  List<Widget> getDropDownFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(new DropdownButton(
      hint: new Text('Select Goal Type'),
      items: _planTypeLists,
      value: _planType,
      onChanged: (value) {
        setState(() {
          _planType = value;
        });
      },
      isExpanded: true,
    ));

    return formWidget;
  }

  @override
  void initState() {
    super.initState();
    _goalTextController = TextEditingController();
    _breakDayTextController = TextEditingController();
  }

  @override
  void dispose() {
    _goalTextController.dispose();
    _breakDayTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // load planlist into form
    loadplanTypeLists();

    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        height: 400,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Form(
          key: _formKeyCreatePlan,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Create Plan'),
              SizedBox(
                height: 20,
              ),
              Text('Type of Goal'),
              Container(
                width: 200,
                height: 80,
                child: ListView(
                  children: getDropDownFormWidget(),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: 300,
                child: TextFormField(
                  decoration: loadDecoration(),
                  controller: _goalTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill the goal';
                    }

                    switch (_planType) {
                      case 0:
                        {
                          try {
                            double distance = double.parse(value);
                            if (distance <= 0) {
                              return 'Please fill the number greater than 0';
                            }
                          } catch (err) {
                            return 'Please fill only number in kilometer';
                          }
                          break;
                        }
                      case 1:
                        {
                          try {
                            int step = int.parse(value);
                            if (step <= 0) {
                              return 'Please fill the number greater than 0';
                            }
                          } catch (err) {
                            return 'Please fill only integer';
                          }
                          break;
                        }

                      case 2:
                        {
                          try {
                            int bpm = int.parse(value);
                            if (bpm <= 0) {
                              return 'Please fill the number greater than 0';
                            }
                            if (bpm > 220) {
                              return 'Please fill the number less than 220';
                            }
                          } catch (err) {
                            return 'Please fill only integer';
                          }
                          break;
                        }
                    }
                    return null;
                  },
                  expands: false,
                ),
              ),
              Container(
                width: 300,
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(MdiIcons.sleep),
                    labelText: 'Rest day per week',
                    hintText: 'Max 2 day per week',
                  ),
                  controller: _breakDayTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill rest-day';
                    }
                    try {
                      int day = int.parse(value);
                      if (day < 0) {
                        return 'Please fill only positive number';
                      } else if (day > 2) {
                        return 'Maximum day is 2';
                      }
                    } catch (e) {
                      return 'Please fill only integer';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RaisedButton(
                child: Text('Create Plan'),
                onPressed: () {
                  if (_formKeyCreatePlan.currentState.validate() == null ||
                      _planType == null) {
                    widget.scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text('Please fill all reqiured data'),
                      ),
                    );
                    return null;
                  }
                  widget.scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Please Wait'),
                    ),
                  );
                  PlanModel plan = PlanModel(
                    goal: PlanGoalModel(
                      planType: PlanGoalType.values[_planType],
                      goal: _goalTextController.value.text,
                    ),
                    breakDay: int.parse(_breakDayTextController.value.text),
                  );
                  print(plan.toString());
                  // trigger event
                  BlocProvider.of<PlanBloc>(context).add(
                    PlanCreating(
                      planModel: plan,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
