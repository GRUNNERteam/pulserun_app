import 'dart:convert';

class PlanModel {
  int planId;
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
      'start': start?.millisecondsSinceEpoch,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlanModel(
      planId: map['planId'],
      targetHeartRate: map['targetHeartRate'],
      start: DateTime.fromMillisecondsSinceEpoch(map['start']),
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