import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HeartRateModel {
  List<HeartRateItem> hrList;
  HeartRateModel({
    this.hrList,
  });

  void addItem(HeartRateItem value) {
    this.hrList.add(value);
  }

  HeartRateModel copyWith({
    List<HeartRateItem> hrList,
  }) {
    return HeartRateModel(
      hrList: hrList ?? this.hrList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hrList': hrList?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory HeartRateModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HeartRateModel(
      hrList: List<HeartRateItem>.from(
          map['hrList']?.map((x) => HeartRateItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HeartRateModel.fromJson(String source) =>
      HeartRateModel.fromMap(json.decode(source));

  @override
  String toString() => 'HeartRateModel(hrList: $hrList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HeartRateModel && listEquals(o.hrList, hrList);
  }

  @override
  int get hashCode => hrList.hashCode;
}

class HeartRateItem {
  final double hr;

  final DateTime ts;

  HeartRateItem(
    this.hr,
    this.ts,
  );

  HeartRateItem copyWith({
    double hr,
    DateTime ts,
  }) {
    return HeartRateItem(
      hr ?? this.hr,
      ts ?? this.ts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hr': hr,
      'ts': ts?.millisecondsSinceEpoch,
    };
  }

  factory HeartRateItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HeartRateItem(
      map['hr'],
      DateTime.fromMillisecondsSinceEpoch(map['ts']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HeartRateItem.fromJson(String source) =>
      HeartRateItem.fromMap(json.decode(source));

  @override
  String toString() => 'HeartRateItem(hr: $hr, ts: $ts)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HeartRateItem && o.hr == hr && o.ts == ts;
  }

  @override
  int get hashCode => hr.hashCode ^ ts.hashCode;
}