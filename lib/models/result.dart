import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pulserun_app/models/heartrate.dart';

class ResultModel {
  String totalTime;
  HearRateModel totalHeartrate;
  double totalDdistance;
  ResultModel({
    this.totalTime,
    this.totalHeartrate,
    this.totalDdistance,
  });

  ResultModel copyWith({
    String totalTime,
    HearRateModel totalHeartrate,
    double totalDdistance,
  }) {
    return ResultModel(
      totalTime: totalTime ?? this.totalTime,
      totalHeartrate: totalHeartrate ?? this.totalHeartrate,
      totalDdistance: totalDdistance ?? this.totalDdistance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalTime': totalTime,
      'totalHeartrate': totalHeartrate?.toMap(),
      'totalDdistance': totalDdistance,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResultModel(
      totalTime: map['totalTime'],
      totalHeartrate: HearRateModel.fromMap(map['totalHeartrate']),
      totalDdistance: map['totalDdistance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultModel.fromJson(String source) =>
      ResultModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ResultModel(totalTime: $totalTime, totalHeartrate: $totalHeartrate, totalDdistance: $totalDdistance)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ResultModel &&
        o.totalTime == totalTime &&
        o.totalHeartrate == totalHeartrate &&
        o.totalDdistance == totalDdistance;
  }

  @override
  int get hashCode =>
      totalTime.hashCode ^ totalHeartrate.hashCode ^ totalDdistance.hashCode;
}
