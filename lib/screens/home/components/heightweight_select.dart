import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';

class HeightWeightSelectBox extends StatefulWidget {
  const HeightWeightSelectBox({Key key}) : super(key: key);

  @override
  _HeightWeightSelectBoxState createState() => _HeightWeightSelectBoxState();
}

class _HeightWeightSelectBoxState extends State<HeightWeightSelectBox> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _height;
  TextEditingController _weight;

  @override
  void initState() {
    super.initState();
    _height = TextEditingController();
    _weight = TextEditingController();
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: Container(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Please Fill Height and Weight'),
                  TextFormField(
                    controller: _height,
                    decoration: const InputDecoration(
                      icon: Icon(MdiIcons.humanMaleHeight),
                      hintText: 'Fill between 1-275',
                      labelText: 'Your height in CM ?',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill Height';
                      }
                      try {
                        print(value);
                        double valueDouble = double.parse(value);
                        if (valueDouble < 1.0 || valueDouble > 275.0) {
                          return 'Please Fill Between 1-275';
                        }
                      } catch (err) {
                        return 'Invalid height';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _weight,
                    decoration: const InputDecoration(
                      icon: Icon(MdiIcons.weightKilogram),
                      hintText: 'Fill between 1-200',
                      labelText: 'Your height in KG ?',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill Weight';
                      }
                      try {
                        print(value);
                        double valueDouble = double.parse(value);
                        if (valueDouble < 1.0 || valueDouble > 200) {
                          return 'Please Fill Between 1-200';
                        }
                      } catch (err) {
                        return 'Invalid Weight';
                      }

                      return null;
                    },
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {
                      if (_formKey.currentState.validate() != null) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );
                        double h = double.parse(_height.value.text);
                        double w = double.parse(_weight.value.text);
                        BlocProvider.of<HomeCubit>(context).updateUser(
                          height: h,
                          weight: w,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
