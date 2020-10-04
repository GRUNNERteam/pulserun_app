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
  ScheduleModel({
    this.events,
    this.isDone,
  });

  ScheduleModel copyWith({
    Map<DateTime, List> events,
    bool isDone,
  }) {
    return ScheduleModel(
      events: events ?? this.events,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'events': events,
      'isDone': isDone,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ScheduleModel(
      events: Map<DateTime, List>.from(map['events']),
      isDone: map['isDone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source));

  @override
  String toString() => 'ScheduleModel(events: $events, isDone: $isDone)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ScheduleModel &&
        mapEquals(o.events, events) &&
        o.isDone == isDone;
  }

  @override
  int get hashCode => events.hashCode ^ isDone.hashCode;
}
