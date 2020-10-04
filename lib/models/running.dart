import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RunningModel {
  String runId;
  //RunningModelItem runningItem;
  DateTime startTime;
  DateTime endTime;
  String estimatedTime;
  double distance;
  RunningModel(
      {this.runId,
      this.startTime,
      this.endTime,
      this.estimatedTime,
      this.distance});

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

  Future<void> updateDistance(double distance) async {
    this.distance = distance;
  }

  Map<String, dynamic> toMap() {
    if (endTime != null) {
      return {
        'runId': runId,
        'startTime': Timestamp.fromMillisecondsSinceEpoch(
            startTime?.millisecondsSinceEpoch),
        'endTime': Timestamp.fromMillisecondsSinceEpoch(
            endTime?.millisecondsSinceEpoch),
        'estimatedTime': estimatedTime,
        'distance': distance,
      };
    } else {
      return {
        'runId': runId,
        'startTime': Timestamp.fromMillisecondsSinceEpoch(
            startTime?.millisecondsSinceEpoch),
        'distance': distance,
      };
    }
  }

  String toJson() => json.encode(toMap());

  factory RunningModel.fromJson(String source) =>
      RunningModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RunningModel(runId: $runId, startTime: $startTime, endTime: $endTime, estimatedTime: $estimatedTime,distance: $distance)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RunningModel &&
        o.runId == runId &&
        o.startTime == startTime &&
        o.endTime == endTime &&
        o.estimatedTime == estimatedTime &&
        o.distance == distance;
  }

  @override
  int get hashCode {
    return runId.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        estimatedTime.hashCode ^
        distance.hashCode;
  }

  RunningModel copyWith({
    String runId,
    DateTime startTime,
    DateTime endTime,
    String estimatedTime,
    double distance,
  }) {
    return RunningModel(
      runId: runId ?? this.runId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      distance: distance ?? this.distance,
    );
  }

  factory RunningModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Timestamp startts = map['startTime'];
    Timestamp endts = map['endTime'] ?? null;
    return RunningModel(
      runId: map['runId'],
      startTime: startts.toDate(),
      endTime: endts.toDate() ?? null,
      estimatedTime: map['estimatedTime'] ?? null,
      distance: map['distance'],
    );
  }
}

//  this.runId,
//   this.startTime,
//   this.endTime,
