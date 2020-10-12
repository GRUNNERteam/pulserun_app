import 'dart:convert';


import 'package:pulserun_app/models/heartrate.dart';

class ResultModel {
  String totalTime;
  HearRateModel totalHeartrate;
  double totalDdistance;
  double avgHearRate;
  ResultModel({
    this.totalTime,
    this.totalHeartrate,
    this.totalDdistance,
    this.avgHearRate,
  });

  ResultModel copyWith({
    String totalTime,
    HearRateModel totalHeartrate,
    double totalDdistance,
    double avgHearRate,
  }) {
    return ResultModel(
      totalTime: totalTime ?? this.totalTime,
      totalHeartrate: totalHeartrate ?? this.totalHeartrate,
      totalDdistance: totalDdistance ?? this.totalDdistance,
      avgHearRate: avgHearRate ?? this.avgHearRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalTime': totalTime,
      'totalHeartrate': totalHeartrate?.toMap(),
      'totalDdistance': totalDdistance,
      'avgHearRate': avgHearRate,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResultModel(
      totalTime: map['totalTime'],
      totalHeartrate: HearRateModel.fromMap(map['totalHeartrate']),
      totalDdistance: map['totalDdistance'],
      avgHearRate: map['avgHearRate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultModel.fromJson(String source) =>
      ResultModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResultModel(totalTime: $totalTime, totalHeartrate: $totalHeartrate, totalDdistance: $totalDdistance, avgHearRate: $avgHearRate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ResultModel &&
        o.totalTime == totalTime &&
        o.totalHeartrate == totalHeartrate &&
        o.totalDdistance == totalDdistance &&
        o.avgHearRate == avgHearRate;
  }

  @override
  int get hashCode {
    return totalTime.hashCode ^
        totalHeartrate.hashCode ^
        totalDdistance.hashCode ^
        avgHearRate.hashCode;
  }
}
