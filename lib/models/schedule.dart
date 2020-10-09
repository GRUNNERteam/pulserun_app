import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ScheduleListModel {
  List<ScheduleModel> scheduleList = [];
  ScheduleListModel({
    this.scheduleList,
  });

  final Timestamp updateAt = Timestamp.fromMillisecondsSinceEpoch(
    DateTime.now().millisecondsSinceEpoch,
  );

  ScheduleListModel copyWith({
    List<ScheduleModel> scheduleList,
  }) {
    return ScheduleListModel(
      scheduleList: scheduleList ?? this.scheduleList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scheduleList': scheduleList?.map((x) => x?.toMap())?.toList(),
      'updateAt': updateAt
    };
  }

  factory ScheduleListModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ScheduleListModel(
      scheduleList: List<ScheduleModel>.from(
          map['scheduleList']?.map((x) => ScheduleModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleListModel.fromJson(String source) =>
      ScheduleListModel.fromMap(json.decode(source));

  @override
  String toString() => 'ScheduleListModel(scheduleList: $scheduleList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleListModel && listEquals(o.scheduleList, scheduleList);
  }

  @override
  int get hashCode => scheduleList.hashCode;
}

class ScheduleCalendarModel {
  final DateTime appointment;
  final List<String> events;
  ScheduleCalendarModel({
    this.appointment,
    this.events,
  });

  ScheduleCalendarModel copyWith({
    DateTime appointment,
    List<String> events,
  }) {
    return ScheduleCalendarModel(
      appointment: appointment ?? this.appointment,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointment': Timestamp.fromMillisecondsSinceEpoch(
        appointment?.millisecondsSinceEpoch,
      ),
      'events': events,
    };
  }

  factory ScheduleCalendarModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Timestamp timestamp = map['appointment'];
    return ScheduleCalendarModel(
      appointment: timestamp.toDate(),
      events: List<String>.from(map['events']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleCalendarModel.fromJson(String source) =>
      ScheduleCalendarModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ScheduleCalendarModel(appointment: $appointment, events: $events)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleCalendarModel &&
        o.appointment == appointment &&
        listEquals(o.events, events);
  }

  @override
  int get hashCode => appointment.hashCode ^ events.hashCode;
}

class ScheduleModel {
  ScheduleCalendarModel calendarModel;
  ScheduleGoalModel goalModel;
  bool isRestDay;
  bool isDone;
  DateTime ts;

  ScheduleModel({
    this.calendarModel,
    this.goalModel,
    this.isRestDay,
    this.isDone,
    this.ts,
  });

  ScheduleModel copyWith({
    ScheduleCalendarModel calendarModel,
    ScheduleGoalModel goalModel,
    bool isDone,
    DateTime ts,
  }) {
    return ScheduleModel(
      calendarModel: calendarModel ?? this.calendarModel,
      goalModel: goalModel ?? this.goalModel,
      isRestDay: isRestDay ?? this.isRestDay,
      isDone: isDone ?? this.isDone,
      ts: ts ?? this.ts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calendarModel': calendarModel?.toMap(),
      'goalModel': goalModel?.toMap(),
      'isRestDay': isRestDay,
      'isDone': isDone,
      'ts': Timestamp.fromMillisecondsSinceEpoch(
        ts?.millisecondsSinceEpoch,
      ),
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Timestamp timestamp = map['ts'];

    return ScheduleModel(
      calendarModel: ScheduleCalendarModel.fromMap(map['calendarModel']),
      goalModel: ScheduleGoalModel.fromMap(map['goalModel']),
      isRestDay: map['isRestDay'],
      isDone: map['isDone'],
      ts: timestamp.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScheduleModel(calendarModel: $calendarModel, goalModel: $goalModel, isRestDay: $isRestDay, isDone: $isDone, ts: $ts)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleModel &&
        o.calendarModel == calendarModel &&
        o.goalModel == goalModel &&
        o.isRestDay == isRestDay &&
        o.isDone == isDone &&
        o.ts == ts;
  }

  @override
  int get hashCode {
    return calendarModel.hashCode ^
        goalModel.hashCode ^
        isRestDay.hashCode ^
        isDone.hashCode ^
        ts.hashCode;
  }
}

class DurationModel {
  DateTime start;
  DateTime end;
  DurationModel({
    @required this.start,
    @required this.end,
  });

  Duration durationTime() {
    if (this.start == null || this.end == null) {
      return null;
    }

    Duration diff = this.start.difference(this.end);
    return diff;
  }

  void addWithDuration(Duration duration) {
    if (duration != null) {
      return;
    }

    this.start = DateTime.now();
    this.end = start.add(duration);
  }

  DurationModel copyWith({
    DateTime start,
    DateTime end,
  }) {
    return DurationModel(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start':
          Timestamp.fromMillisecondsSinceEpoch(start.millisecondsSinceEpoch),
      'end': Timestamp.fromMillisecondsSinceEpoch(end.millisecondsSinceEpoch),
    };
  }

  factory DurationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Timestamp start = map['start'] ?? null;
    Timestamp end = map['end'] ?? null;

    return DurationModel(
      start: start.toDate(),
      end: end.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DurationModel.fromJson(String source) =>
      DurationModel.fromMap(json.decode(source));

  @override
  String toString() => 'DurationModel(start: $start, end: $end)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DurationModel && o.start == start && o.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

enum ScheduleGoalType {
  none,
  distance,
  step,
  time,
}

extension ScheduleGoalTypeExtension on ScheduleGoalType {
  // Helper functions
  String enumToString(Object o) => o.toString().split('.').last;

  T enumFromString<T>(String key, List<T> values) =>
      values.firstWhere((v) => key == enumToString(v), orElse: () => null);
}

class ScheduleGoalModel {
  ScheduleGoalType scheduleGoalType;
  double distance;
  int step;
  DurationModel time;

  ScheduleGoalModel({
    this.scheduleGoalType,
    this.distance,
    this.step,
    this.time,
  });

  dynamic getGoal() {
    if (this.scheduleGoalType == null || this.scheduleGoalType.index == 0) {
      return null;
    }
    switch (this.scheduleGoalType.index) {
      case 1:
        {
          return this.distance;
        }

      case 2:
        {
          return this.step;
        }
      case 3:
        {
          return this.time.durationTime();
        }
      default:
        {
          return null;
        }
    }
  }

  ScheduleGoalModel copyWith({
    ScheduleGoalType scheduleGoalType,
    double distance,
    int step,
    DurationModel time,
  }) {
    return ScheduleGoalModel(
      scheduleGoalType: scheduleGoalType ?? this.scheduleGoalType,
      distance: distance ?? this.distance,
      step: step ?? this.step,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scheduleGoalType': scheduleGoalType?.index,
      'distance': distance,
      'step': step,
      'time': time?.toMap(),
    };
  }

  factory ScheduleGoalModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ScheduleGoalModel(
      scheduleGoalType: ScheduleGoalType.values[map['scheduleGoalType']],
      distance: map['distance'],
      step: map['step'],
      time: DurationModel.fromMap(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleGoalModel.fromJson(String source) =>
      ScheduleGoalModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScheduleGoalModel(scheduleGoalType: $scheduleGoalType, distance: $distance, step: $step, time: $time)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleGoalModel &&
        o.scheduleGoalType == scheduleGoalType &&
        o.distance == distance &&
        o.step == step &&
        o.time == time;
  }

  @override
  int get hashCode {
    return scheduleGoalType.hashCode ^
        distance.hashCode ^
        step.hashCode ^
        time.hashCode;
  }
}
