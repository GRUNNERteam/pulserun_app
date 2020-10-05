import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ScheduleListModel {
  List<ScheduleModel> scheduleList = [];
  ScheduleListModel({
    this.scheduleList,
  });

  void addEntireFromGenerateService(List<Map<DateTime, List>> list) {
    list.forEach((map) {
      this.scheduleList.add(ScheduleModel(events: map, isDone: false));
    });
  }

  final Timestamp updateAt = Timestamp.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch);

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

class ScheduleModel {
  Map<DateTime, List> events;
  bool isDone;
  double distance;
  DurationModel estmatetime;
  ScheduleModel({
    this.events,
    this.isDone,
    this.distance,
    this.estmatetime,
  });

  ScheduleModel copyWith({
    Map<DateTime, List> events,
    bool isDone,
    double distance,
    DurationModel estmatetime,
  }) {
    return ScheduleModel(
      events: events ?? this.events,
      isDone: isDone ?? this.isDone,
      distance: distance ?? this.distance,
      estmatetime: estmatetime ?? this.estmatetime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'events': events,
      'isDone': isDone,
      'distance': distance,
      'estmatetime': estmatetime?.toMap(),
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ScheduleModel(
      events: Map<DateTime, List>.from(map['events']),
      isDone: map['isDone'],
      distance: map['distance'],
      estmatetime: DurationModel.fromMap(map['estmatetime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScheduleModel(events: $events, isDone: $isDone, distance: $distance, estmatetime: $estmatetime)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleModel &&
        mapEquals(o.events, events) &&
        o.isDone == isDone &&
        o.distance == distance &&
        o.estmatetime == estmatetime;
  }

  @override
  int get hashCode {
    return events.hashCode ^
        isDone.hashCode ^
        distance.hashCode ^
        estmatetime.hashCode;
  }
}

class DurationModel {
  DateTime start;
  DateTime end;
  DurationModel({
    this.start,
    this.end,
  });

  Duration durationTime() {
    if (this.start == null || this.end == null) {
      return null;
    }

    Duration diff = this.start.difference(this.end);
    return diff;
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
