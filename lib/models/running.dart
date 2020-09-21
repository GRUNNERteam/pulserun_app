import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RunningModel {
  String runId;
  //RunningModelItem runningItem;
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

  Map<String, dynamic> toMap() {
    if (endTime != null) {
      return {
        'runId': runId,
        'startTime': Timestamp.fromMillisecondsSinceEpoch(
            startTime?.millisecondsSinceEpoch),
        'endTime': Timestamp.fromMillisecondsSinceEpoch(
            endTime?.millisecondsSinceEpoch)
      };
    } else {
      return {
        'runId': runId,
        'startTime': Timestamp.fromMillisecondsSinceEpoch(
            startTime?.millisecondsSinceEpoch),
      };
    }
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
    Timestamp startts = map['startTime'];
    Timestamp endts = map['endTime'] ?? null;
    return RunningModel(
      runId: map['runId'],
      startTime: startts.toDate(),
      endTime: endts.toDate() ?? null,
    );
  }
}

//  this.runId,
//   this.startTime,
//   this.endTime,
