import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum PlanGoalType {
  distance,
  step,
  heartRate,
}

extension PlanGoalTypeExtension on PlanGoalType {
  // Helper functions
  String enumToString(Object o) => o.toString().split('.').last;

  T enumFromString<T>(String key, List<T> values) =>
      values.firstWhere((v) => key == enumToString(v), orElse: () => null);
}

class PlanWeekly {}

class PlanGoalModel {
  PlanGoalType planType;
  String goal;
  PlanGoalModel({
    this.planType,
    this.goal,
  });

  PlanGoalModel copyWith({
    PlanGoalType planType,
    double goal,
  }) {
    return PlanGoalModel(
      planType: planType ?? this.planType,
      goal: goal ?? this.goal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planType': planType.index,
      'goal': goal,
    };
  }

  factory PlanGoalModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlanGoalModel(
      planType: PlanGoalType.values[map['planType']],
      goal: map['goal'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanGoalModel.fromJson(String source) =>
      PlanGoalModel.fromMap(json.decode(source));

  @override
  String toString() => 'PlanGoalModel(planType: $planType, goal: $goal)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlanGoalModel && o.planType == planType && o.goal == goal;
  }

  @override
  int get hashCode => planType.hashCode ^ goal.hashCode;
}

class PlanModel {
  String planId;
  PlanGoalModel goal;
  double targetHeartRate;
  DateTime start;
  int breakDay;

  PlanModel({
    this.planId,
    this.goal,
    this.targetHeartRate,
    this.start,
    this.breakDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'planId': planId,
      'goal': goal.toMap(),
      'targetHeartRate': targetHeartRate,
      'start':
          Timestamp.fromMillisecondsSinceEpoch(start?.millisecondsSinceEpoch),
      'breakDay': breakDay,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Timestamp startts = map['start'];
    return PlanModel(
      planId: map['planId'],
      goal: PlanGoalModel.fromMap(map['goal']),
      targetHeartRate: map['targetHeartRate'],
      start: startts.toDate(),
      breakDay: map['breakDay'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) =>
      PlanModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlanModel &&
        o.planId == planId &&
        o.goal == goal &&
        o.targetHeartRate == targetHeartRate &&
        o.start == start &&
        o.breakDay == breakDay;
  }

  @override
  int get hashCode =>
      planId.hashCode ^
      goal.hashCode ^
      targetHeartRate.hashCode ^
      start.hashCode ^
      breakDay.hashCode;

  PlanModel copyWith({
    int planId,
    PlanGoalModel goal,
    double targetHeartRate,
    DateTime start,
    int breakDay,
  }) {
    return PlanModel(
      planId: planId ?? this.planId,
      goal: goal ?? this.goal,
      targetHeartRate: targetHeartRate ?? this.targetHeartRate,
      start: start ?? this.start,
      breakDay: breakDay ?? this.breakDay,
    );
  }

  @override
  String toString() {
    return 'PlanModel(planId: $planId, goal: $goal, targetHeartRate: $targetHeartRate, start: $start, breakDay: $breakDay)';
  }
}
