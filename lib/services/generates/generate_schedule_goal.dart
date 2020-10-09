import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/schedule.dart';

class GenerateGoalScheduleService {
  PlanModel planModel;
  List<Map<DateTime, List>> events;
  GenerateGoalScheduleService({
    @required this.planModel,
    @required this.events,
  });

  List<ScheduleGoalModel> generateGoalSchedule() {
    if (this.events == null) {
      print('events is null');
      return null;
    }
    List<ScheduleGoalModel> scheduleGoalLists = [];

    int length = events.length;
    double distance = double.tryParse(this.planModel.goal.goal);
    int step = int.tryParse(this.planModel.goal.goal);
    int avgHeartRate = int.tryParse(this.planModel.goal.goal);

    this.events.forEach((element) {
      print(element.values.single);
      List<String> event = [];
      event.add(element.values.single.toString());
      // add goal to event
      ScheduleGoalModel scheduleGoalModel = ScheduleGoalModel();
      // https://www.mayoclinic.org/healthy-lifestyle/fitness/expert-answers/exercise/faq-20057916
      // 15 <= min warm-up
      // 30 >= min running time
      // 15 <= min cooldown
      // normal run should be around 1 hours

      switch (this.planModel.goal.planType.index) {
        case 0:
          {
            // distance
            scheduleGoalModel.scheduleGoalType = ScheduleGoalType.distance;
            if ((events.length * 0.8) > length) {
              // start day
              double d = distance * (0.2 * length);
              distance -= d;
              scheduleGoalModel.distance = d;
              break;
            }
            if (length.isOdd) {
              double d = distance * (0.5 * length);
              distance -= d;
              scheduleGoalModel.distance = d;
              break;
            } else {
              double d = distance * (0.8 * length);
              distance -= d;
              scheduleGoalModel.distance = d;
              break;
            }

            if (distance > 0 && length == 0) {
              double d = distance;
              distance -= d;
              scheduleGoalModel.distance = d;
              break;
            }

            break;
          }
        case 1:
          {
            // step
            scheduleGoalModel.scheduleGoalType = ScheduleGoalType.step;
            if ((events.length * 0.8) > length) {
              // start day
              double d = step * (0.2 * length);
              step -= d.toInt();
              scheduleGoalModel.step = d.toInt();
              break;
            }
            if (length.isOdd) {
              double d = step * (0.5 * length);
              step -= d.toInt();
              scheduleGoalModel.step = d.toInt();
              break;
            } else {
              double d = step * (0.8 * length);
              step -= d.toInt();
              scheduleGoalModel.step = d.toInt();
              break;
            }

            if (distance > 0 && length == 0) {
              double d = step.toDouble();
              step -= d.toInt();
              scheduleGoalModel.step = d.toInt();
              break;
            }

            break;
          }
        case 2:
          {
            // avgHeartRate

            scheduleGoalModel.scheduleGoalType = ScheduleGoalType.time;
            break;
          }

        default:
          {
            break;
          }
      }

      // static add schedule
      event.add('15 minture for warm-up');
      Random randomObject = Random();
      int time = 30 + randomObject.nextInt(45);
      event.add('$time minture for running');
      event.add('15 minture for cooldown');
      Duration duration = Duration(minutes: 30 + time);
      DateTime t = DateTime.now();
      DurationModel durationModel =
          DurationModel(start: t, end: t.add(duration));

      scheduleGoalModel.time = durationModel;

      length--;

      print(scheduleGoalModel.toString());

      scheduleGoalLists.add(scheduleGoalModel);
    });

    return scheduleGoalLists;
  }
}
