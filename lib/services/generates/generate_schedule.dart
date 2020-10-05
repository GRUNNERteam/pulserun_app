import 'dart:math';

import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/plan.dart';

class GenerateScheduleService {
  List<Map<DateTime, List>> generateScheduleWeekly(PlanModel plan,
      {DateTime startDay}) {
    List<Map<DateTime, List>> list = [];
    int restday = plan.breakDay;
    Map<DateTime, List> e = Map<DateTime, List>();
    DateTime createDay = plan.start;
    if (startDay != null) {
      createDay = startDay;
    }
    Random randomObject = new Random();
    int a = 0;
    int b = 50;
    List<String> event = [];
    for (int i; i < 7; i++) {
      event = [];
      if (restday > 0) {
        a = randomObject.nextInt(100);
        b = randomObject.nextInt(100);
        if (a > b) {
          event.add('Rest Day');
        } else {
          event.add('Run Day');
        }
      } else {
        event.add('Run Day');
      }
      Map<DateTime, List> s = {createDay.add(Duration(days: i)): event};
      list.add(s);
    }
    return list;
  }

  List<Map<DateTime, List>> generateScheduleMonthly(PlanModel plan,
      {DateTime startDay}) {
    // 7 * 4 28 will create only 28 day
    List<Map<DateTime, List>> list = [];
    DateTime createWeek = startDay;
    List<Map<DateTime, List>> holder = [];
    for (int i; i < 4; i++) {
      createWeek.add(Duration(days: 7 * i));
      holder.clear();
      holder = this.generateScheduleWeekly(plan, startDay: createWeek);
      holder.forEach((element) {
        list.add(element);
      });
    }

    return list;
  }
}

class GenerateScheduleByBMIService extends GenerateScheduleService {
  /// https://www.runnersworld.com/uk/training/beginners/a772727/how-to-start-running-today
  /// Ref A 7 week* walking plan to get your body ready for running:

  final CurrentStatusModel statusModel;

  GenerateScheduleByBMIService(
    this.statusModel,
  );

  @override
  List<Map<DateTime, List>> generateScheduleWeekly(PlanModel plan,
      {DateTime startDay}) {
    List<Map<DateTime, List>> list = [];
    int restday = plan.breakDay;
    Map<DateTime, List> e = Map<DateTime, List>();
    DateTime createDay = plan.start;
    if (startDay != null) {
      createDay = startDay;
    }
    List<String> event = [];
    for (int i; i < 7; i++) {
      event = [];
      if (restday > 0) {
        if (i == 4 || i == 6) {
          event.add('Rest Day');
        } else {
          event.add('Run Day');
        }
      } else {
        event.add('Run Day');
      }
      Map<DateTime, List> s = {createDay.add(Duration(days: i)): event};
      list.add(s);
    }

    return list;
  }
}
