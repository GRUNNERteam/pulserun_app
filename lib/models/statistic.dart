import 'dart:convert';

import 'package:pulserun_app/models/currentstatus.dart';

class StatisticModel {
  int statId;
  DateTime lastUpdate;
  StatisticModel({
    this.statId,
    this.lastUpdate,
  });
  CurrentStatusModel _currentStatus = CurrentStatusModel();

  StatisticModel copyWith({
    int statId,
    DateTime lastUpdate,
  }) {
    return StatisticModel(
      statId: statId ?? this.statId,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statId': statId,
      'lastUpdate': lastUpdate?.millisecondsSinceEpoch,
    };
  }

  factory StatisticModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StatisticModel(
      statId: map['statId'],
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(map['lastUpdate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticModel.fromJson(String source) =>
      StatisticModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'StatisticModel(statId: $statId, lastUpdate: $lastUpdate)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StatisticModel &&
        o.statId == statId &&
        o.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode => statId.hashCode ^ lastUpdate.hashCode;
}
