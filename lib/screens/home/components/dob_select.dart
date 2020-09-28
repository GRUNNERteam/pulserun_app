import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';

class DoBSelectBox extends StatefulWidget {
  const DoBSelectBox({Key key}) : super(key: key);

  @override
  _DoBSelectBoxState createState() => _DoBSelectBoxState();
}

class _DoBSelectBoxState extends State<DoBSelectBox> {
  DateTime selectedDate = DateTime.now();
  bool _isSelected = false;
  Future<void> _selectDate(BuildContext context) async {
    // final DateTime picked = await showDatePicker(
    //   context: context,
    //   initialDate: selectedDate,
    //   firstDate: DateTime(1900),
    //   lastDate: DateTime(2101),
    // );

    final DateTime picked = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _isSelected = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height / 2,
        child: Card(
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Please Fill your Date of Birth"),
                        Text("${selectedDate.toLocal()}".split(' ')[0]),
                        RaisedButton(
                          child: Text('Select Date of Birth'),
                          onPressed: () => _selectDate(context),
                        ),
                        RaisedButton(
                          child: Text('Done'),
                          onPressed: () => _isSelected
                              ? BlocProvider.of<HomeCubit>(context)
                                  .updateUser(dob: selectedDate)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
