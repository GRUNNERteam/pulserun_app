import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum PlanGoalType {
  none,
  step,
  weight,
  avgHeartRate,
}

class PlanWeekly {}

class PlanGoalModel {
  PlanGoalType planType;
  double goal;
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
      'planType': planType,
      'goal': goal,
    };
  }

  factory PlanGoalModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlanGoalModel(
      planType: map['planType'],
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
  int planId;
  PlanGoalModel goal;
  double targetHeartRate;
  DateTime start;

  PlanModel({
    this.planId,
    this.targetHeartRate,
    this.start,
  });

  Map<String, dynamic> toMap() {
    return {
      'planId': planId,
      'targetHeartRate': targetHeartRate,
      'start':
          Timestamp.fromMillisecondsSinceEpoch(start?.millisecondsSinceEpoch),
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Timestamp startts = map['start'];
    return PlanModel(
      planId: map['planId'],
      targetHeartRate: map['targetHeartRate'],
      start: startts.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) =>
      PlanModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlanModel(planId: $planId, targetHeartRate: $targetHeartRate, start: $start)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlanModel &&
        o.planId == planId &&
        o.targetHeartRate == targetHeartRate &&
        o.start == start;
  }

  @override
  int get hashCode =>
      planId.hashCode ^ targetHeartRate.hashCode ^ start.hashCode;

  PlanModel copyWith({
    int planId,
    double targetHeartRate,
    DateTime start,
  }) {
    return PlanModel(
      planId: planId ?? this.planId,
      targetHeartRate: targetHeartRate ?? this.targetHeartRate,
      start: start ?? this.start,
    );
  }
}
