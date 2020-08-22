import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/cubit/running_cubit.dart';

class RunningPage extends StatelessWidget {
  const RunningPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<RunningCubit, RunningState>(
          builder: (context, state) {
            if (state is RunningInitial) {
              return _buildbodyInit(context);
            } else if (state is RunningLoading) {
              return LoadingWidget();
            } else if (state is RunningLoaded) {
              return _buildbody();
            } else if (state is RunningWorking) {
              return LoadingWidget();
            } else if (state is RunningResult) {
            } else {
              return ShowErrorWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildbody() {
    return Stack();
  }

  Widget _buildbodyInit(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0XFF00B686), Color(0XFF00838F)],
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Plan Infomation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Text('plan Id'),
                              Text('0'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('target hr'),
                              Text('170'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Current BMI'),
                              Text('20'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Need To Run'),
                            Text('2 KM.'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 60),
                    height: 300,
                    width: 300,
                    child: RaisedButton(
                      color: Colors.red.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      onPressed: () {
                        BlocProvider.of<RunningCubit>(context).startRun();
                      },
                      child: ColorizeAnimatedTextKit(
                        text: ["Start"],
                        textStyle: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: [
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                        ],
                        repeatForever: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
