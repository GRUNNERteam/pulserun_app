import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/screens/running/running.dart';

class GenerateScheduleService {
  Future<ScheduleListModel> generateScheduleWeekly(
    @required PlanModel planModel,
  ) async {
    if (planModel == null) {
      print('generateScheduleWeekly : planModel is null');
      return await null;
    }

    /// https://www.runnersworld.com/uk/training/beginners/a772727/how-to-start-running-today
    /// Ref A 7 week* walking plan to get your body ready for running:
    ScheduleListModel scheduleListModel = ScheduleListModel();
    List<ScheduleModel> lists = [];
    List<ScheduleModel> listswithGoals = [];

    int restDay = planModel.breakDay;

    // not add goal yet

    int dayCount = 0;

    for (int j = 0; j < 4; j++) {
      restDay = planModel.breakDay;
      for (int i = 0; i < 7; i++) {
        if (restDay > 0) {
          if (i == 4 || i == 6) {
            lists.add(
              ScheduleModel(
                calendarModel: ScheduleCalendarModel(
                  appointment: planModel.start.add(
                    Duration(
                      days: i,
                    ),
                  ),
                  events: ['Rest Day'],
                ),
                isRestDay: true,
                isDone: true,
                ts: planModel.start.add(
                  Duration(
                    days: dayCount,
                  ),
                ),
              ),
            );
            restDay--;
          } else {
            lists.add(
              ScheduleModel(
                calendarModel: ScheduleCalendarModel(
                  appointment: planModel.start.add(
                    Duration(
                      days: dayCount,
                    ),
                  ),
                  events: ['Running Day'],
                ),
                isRestDay: false,
                isDone: false,
                ts: planModel.start.add(
                  Duration(
                    days: dayCount,
                  ),
                ),
              ),
            );
          }
        } else {
          lists.add(
            ScheduleModel(
              calendarModel: ScheduleCalendarModel(
                appointment: planModel.start.add(
                  Duration(
                    days: dayCount,
                  ),
                ),
                events: ['Running Day'],
              ),
              isRestDay: false,
              isDone: false,
              ts: planModel.start.add(
                Duration(
                  days: dayCount,
                ),
              ),
            ),
          );
        }
        dayCount++;
      }
    }

    // Goal update

    double distance = double.tryParse(planModel.goal.goal);
    int step = int.tryParse(planModel.goal.goal);
    int avgHeartRate = int.tryParse(planModel.goal.goal);

    lists.forEach(
      (element) {
        ScheduleGoalModel scheduleGoalModel = new ScheduleGoalModel();
        List<String> instruction = element.calendarModel.events;

        // 50 to 70 minutes
        // warm-up 10
        // cool-down 10

        instruction.add('Warm-up 10 minutes');
        instruction.add('Running 50 minutes');
        instruction.add('Cooldown 10 minutes');

        if (!element.isRestDay) {
          switch (planModel.goal.planType.index) {
            case 0:
              {
                // 56.32704 kilometers per week
                // 8.04672 per day

                if (distance > 0 && !element.isRestDay) {
                  scheduleGoalModel.distance = 8.04672;
                  distance -= 8.04672;
                } else {
                  scheduleGoalModel.distance = distance.abs();
                  distance = 0;
                }
                scheduleGoalModel.scheduleGoalType = ScheduleGoalType.distance;

                // 50 to 70 minutes
                // warm-up 10
                // cool-down 10

                DateTime start = DateTime.now();
                DateTime end = start.add(Duration(minutes: 70));

                scheduleGoalModel.time = DurationModel(start: start, end: end);
                break;
              }
            case 1:
              {
                // 15,000 steps per week

                // 2,000 per day

                if (step > 0 && !element.isRestDay) {
                  scheduleGoalModel.step = 2000;
                  step -= 2000;
                } else {
                  scheduleGoalModel.step = step.abs();
                  step = 0;
                }

                scheduleGoalModel.scheduleGoalType = ScheduleGoalType.step;

                DateTime start = DateTime.now();
                DateTime end = start.add(Duration(minutes: 70));

                scheduleGoalModel.time = DurationModel(start: start, end: end);
                break;
              }
            case 2:
              {
                scheduleGoalModel.scheduleGoalType = ScheduleGoalType.step;

                DateTime start = DateTime.now();
                DateTime end = start.add(Duration(minutes: 70));

                scheduleGoalModel.time = DurationModel(start: start, end: end);
                break;
              }
            default:
              {}
          }
          listswithGoals.add(
            ScheduleModel(
              calendarModel: ScheduleCalendarModel(
                appointment: element.calendarModel.appointment,
                events: instruction,
              ),
              goalModel: scheduleGoalModel,
              isRestDay: element.isRestDay,
              isDone: element.isDone,
              ts: element.ts,
            ),
          );
        } else {
          listswithGoals.add(
            ScheduleModel(
              calendarModel: ScheduleCalendarModel(
                appointment: element.calendarModel.appointment,
                events: instruction,
              ),
              goalModel: null,
              isRestDay: element.isRestDay,
              isDone: element.isDone,
              ts: element.ts,
            ),
          );
        }
      },
    );

    scheduleListModel.scheduleList = listswithGoals;
    return scheduleListModel;
  }

  // List<Map<DateTime, List>> generateScheduleWeekly(PlanModel plan,
  //     {DateTime startDay}) {
  //   List<Map<DateTime, List>> list = [];
  //   int restday = plan.breakDay;
  //   Map<DateTime, List> e = Map<DateTime, List>();
  //   DateTime createDay = plan.start;
  //   if (startDay != null) {
  //     createDay = startDay;
  //   }

  //   double distance = 0;
  //   int step = 0;
  //   int avgHeartRate = 0;

  //   Random randomObject = new Random();
  //   int a = 0;
  //   int b = 50;
  //   List<String> event = [];
  //   for (int i = 0; i < 7; i++) {
  //     print(i);
  //     print(createDay.toString());
  //     event = [];
  //     if (restday > 0) {
  //       a = randomObject.nextInt(100);
  //       b = randomObject.nextInt(100);
  //       if (a > b) {
  //         event.add('Rest Day');
  //       } else {
  //         event.add('Run Day');
  //       }
  //     } else {
  //       event.add('Run Day');
  //     }

  //     Map<DateTime, List> s = {createDay.add(Duration(days: i)): event};
  //     list.add(s);
  //   }
  //   return list;
  // }

  // List<Map<DateTime, List>> generateScheduleMonthly(PlanModel plan,
  //     {DateTime startDay}) {
  //   // 7 * 4 28 will create only 28 day
  //   print('generateScheduleMonthly was called.');
  //   List<Map<DateTime, List>> list = [];
  //   DateTime createWeek = startDay ?? plan.start;
  //   List<Map<DateTime, List>> holder = [];

  //   for (int i = 0; i < 4; i++) {
  //     Duration d = Duration(days: 7 * i);
  //     print(i);
  //     createWeek.add(d);
  //     holder.clear();
  //     holder = this.generateScheduleWeekly(plan, startDay: createWeek);
  //     holder.forEach((element) {
  //       list.add(element);
  //     });
  //   }

  //   return list;
  // }
}
