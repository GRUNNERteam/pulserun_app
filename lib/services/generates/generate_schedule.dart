import 'dart:math';

import 'package:pulserun_app/models/plan.dart';

class GenerateScheduleService {
  List<Map<DateTime, List>> GenerateScheduleWeekly(PlanModel plan,
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

  List<Map<DateTime, List>> GenerateScheduleMonthly(PlanModel plan,
      {DateTime startDay}) {
    // 7 * 4 28 will create only 28 day
    List<Map<DateTime, List>> list = [];
    DateTime createWeek = startDay;
    List<Map<DateTime, List>> holder = [];
    for (int i; i < 4; i++) {
      createWeek.add(Duration(days: 7 * i));
      holder.clear();
      holder = this.GenerateScheduleWeekly(plan, startDay: createWeek);
      holder.forEach((element) {
        list.add(element);
      });
    }

    return list;
  }
}
