import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/models/schedule.dart';

class TodayScheduleReminder extends StatelessWidget {
  final ScheduleModel scheduleModel;
  const TodayScheduleReminder({Key key, this.scheduleModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 80,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Schedule Today',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            (scheduleModel.isRestDay == null
                ? _restDay(scheduleModel)
                : _runningDay(scheduleModel)),
          ],
        ),
      ),
    );
  }

  Widget _runningDay(ScheduleModel scheduleModel) {
    String distance = scheduleModel.goalModel.distance != null
        ? scheduleModel.goalModel.distance.toStringAsFixed(2)
        : 'Not Set';
    String step = scheduleModel.goalModel.step != null
        ? scheduleModel.goalModel.step.toString()
        : 'Not Set';
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    String time = format(scheduleModel.goalModel.time.durationTime().abs());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: [
            Text('Distance'),
            Text('$distance KM'),
          ],
        ),
        Column(
          children: [
            Text('Step'),
            Text('$step'),
          ],
        ),
        Column(
          children: [
            Text('Time'),
            Text('$time'),
          ],
        ),
      ],
    );
  }

  Widget _restDay(ScheduleModel scheduleModel) {
    return Row(
      children: <Widget>[
        Text('No running today'),
      ],
    );
  }
}
