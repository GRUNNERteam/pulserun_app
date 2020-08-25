import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';

class RunningModel {
  String runId;
  //RunningModelItem runningItem;
  DateTime createdAt = DateTime.now();
  DateTime startTime;
  DateTime endTime;
  RunningModel({
    this.runId,
    this.startTime,
    this.endTime,
  });

  // void setRunningItem(RunningModelItem item) {
  //   if (this.runningItem == null) {
  //     this.runningItem = item;
  //   }
  // }

  void setRunningId(DocumentReference ref) {
    this.runId = ref.id;
  }

  // ignore: missing_return
  Future<bool> setendTime() async {
    try {
      // ignore: await_only_futures
      this.endTime = await DateTime.now();
    } catch (e) {
      print('setEndTime Error : $e');
    }
  }

  RunningModel copyWith({
    String runId,
    DateTime startTime,
    DateTime endTime,
  }) {
    return RunningModel(
      runId: runId ?? this.runId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  factory RunningModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RunningModel(
      runId: map['runId'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RunningModel.fromJson(String source) =>
      RunningModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RunningModel(runId: $runId, startTime: $startTime, endTime: $endTime)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningModel &&
        o.runId == runId &&
        o.startTime == startTime &&
        o.endTime == endTime;
  }

  @override
  int get hashCode => runId.hashCode ^ startTime.hashCode ^ endTime.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'runId': runId,
      'startTime': startTime?.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
    };
  }
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
