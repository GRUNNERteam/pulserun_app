import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pulserun_app/screens/running/running.dart';

class HearRateModel {
  List<HeartRateItem> heartRate;
  HearRateModel({
    this.heartRate,
  });

  void add_model(int add_hr) {
    if (this.heartRate == null) {
      this.heartRate = List<HeartRateItem>();
    }

    this.heartRate.add(HeartRateItem(hr: add_hr, time: DateTime.now()));
  }

  void set_model(int hr, DateTime time) {
    if (this.heartRate == null) {
      this.heartRate = List<HeartRateItem>();
    }
    this.heartRate.add(HeartRateItem(hr: hr, time: time));
  }

  void clear() {
    if (this.heartRate != null) {
      this.heartRate.clear();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'heartRate': heartRate?.map((x) => x?.toMap())?.toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory HearRateModel.fromJson(String source) =>
      HearRateModel.fromMap(json.decode(source));

  @override
  String toString() => 'HearRateModel(heartRate: $heartRate)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HearRateModel && listEquals(o.heartRate, heartRate);
  }

  @override
  int get hashCode => heartRate.hashCode;

  factory HearRateModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HearRateModel(
      heartRate: List<HeartRateItem>.from(
          map['heartRate']?.map((x) => HeartRateItem.fromMap(x))),
    );
  }

  HearRateModel copyWith({
    List<HeartRateItem> heartRate,
  }) {
    return HearRateModel(
      heartRate: heartRate ?? this.heartRate,
    );
  }
}

class HeartRateItem {
  final int hr;

  final DateTime time;
  HeartRateItem({
    this.hr,
    this.time,
  });

  HeartRateItem copyWith({
    int hr,
    DateTime time,
  }) {
    return HeartRateItem(
      hr: hr ?? this.hr,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hr': hr,
      'time': Timestamp.fromMillisecondsSinceEpoch(time?.millisecondsSinceEpoch)
    };
  }

  factory HeartRateItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Timestamp tmestamp = map['time'];
    return HeartRateItem(
      hr: map['hr'],
      time: tmestamp.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HeartRateItem.fromJson(String source) =>
      HeartRateItem.fromMap(json.decode(source));

  @override
  String toString() => 'HeartRateItem(hr: $hr, time: $time)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HeartRateItem && o.hr == hr && o.time == time;
  }

  @override
  int get hashCode => hr.hashCode ^ time.hashCode;
}
