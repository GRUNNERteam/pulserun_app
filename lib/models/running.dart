import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';

class RunningModel {
  int runId;
  List<RunningModelItem> runningItem;
  RunningModel({
    this.runId,
    this.runningItem,
  });

  RunningModel copyWith({
    int runId,
    List<RunningModelItem> runningItem,
  }) {
    return RunningModel(
      runId: runId ?? this.runId,
      runningItem: runningItem ?? this.runningItem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'runId': runId,
      'runningItem': runningItem?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory RunningModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RunningModel(
      runId: map['runId'],
      runningItem: List<RunningModelItem>.from(
          map['runningItem']?.map((x) => RunningModelItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RunningModel.fromJson(String source) =>
      RunningModel.fromMap(json.decode(source));

  @override
  String toString() => 'RunningModel(runId: $runId, runningItem: $runningItem)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningModel &&
        o.runId == runId &&
        listEquals(o.runningItem, runningItem);
  }

  @override
  int get hashCode => runId.hashCode ^ runningItem.hashCode;
}

class RunningModelItem {
  DateTime startTime;
  DateTime endTime;
  LocationModel tracking;
  HeartRateModel heartrate;

  RunningModelItem(
    this.startTime,
    this.endTime,
    this.tracking,
    this.heartrate,
  );

  RunningModelItem copyWith({
    DateTime startTime,
    DateTime endTime,
    LocationModel tracking,
    HeartRateModel heartrate,
  }) {
    return RunningModelItem(
      startTime ?? this.startTime,
      endTime ?? this.endTime,
      tracking ?? this.tracking,
      heartrate ?? this.heartrate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime?.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'tracking': tracking?.toMap(),
      'heartrate': heartrate?.toMap(),
    };
  }

  factory RunningModelItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RunningModelItem(
      DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      LocationModel.fromMap(map['tracking']),
      HeartRateModel.fromMap(map['heartrate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RunningModelItem.fromJson(String source) =>
      RunningModelItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RunningModelItem(startTime: $startTime, endTime: $endTime, tracking: $tracking, heartrate: $heartrate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningModelItem &&
        o.startTime == startTime &&
        o.endTime == endTime &&
        o.tracking == tracking &&
        o.heartrate == heartrate;
  }

  @override
  int get hashCode {
    return startTime.hashCode ^
        endTime.hashCode ^
        tracking.hashCode ^
        heartrate.hashCode;
  }
}
