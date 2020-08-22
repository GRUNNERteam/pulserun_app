import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  List<PositionModel> position;
  List<CameraPosition> camPosition;
  LocationModel({
    this.position,
    this.camPosition,
  });

  void addPos(PositionModel pos) {
    this.position.add(pos);
    this.camPosition.add(convertPosToCam(pos));
  }

  CameraPosition convertPosToCam(PositionModel pos) {
    // ref MapView
    // https://developers.google.com/maps/documentation/android-sdk/views
    return CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      bearing: pos.heading,
      tilt: 45,
      zoom: 20,
    );
  }

  LocationModel copyWith({
    List<PositionModel> position,
    List<CameraPosition> camPosition,
  }) {
    return LocationModel(
      position: position ?? this.position,
      camPosition: camPosition ?? this.camPosition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'position': position?.map((x) => x?.toMap())?.toList(),
      'camPosition': camPosition?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LocationModel(
      position: List<PositionModel>.from(
          map['position']?.map((x) => PositionModel.fromMap(x))),
      camPosition: List<CameraPosition>.from(
          map['camPosition']?.map((x) => CameraPosition.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LocationModel(position: $position, camPosition: $camPosition)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LocationModel &&
        listEquals(o.position, position) &&
        listEquals(o.camPosition, camPosition);
  }

  @override
  int get hashCode => position.hashCode ^ camPosition.hashCode;
}

class PositionModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final bool mocked;
  final double altitude;
  final double accuracy;
  final double heading;
  final double speed;
  final double speedAccuracy;
  PositionModel({
    this.latitude,
    this.longitude,
    this.timestamp,
    this.mocked,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  PositionModel convertGeoPosToCustom(Position pos) {
    return PositionModel(
      latitude: pos.latitude,
      longitude: pos.longitude,
      timestamp: pos.timestamp,
      mocked: pos.mocked,
      altitude: pos.altitude,
      accuracy: pos.accuracy,
      heading: pos.heading,
      speed: pos.speed,
      speedAccuracy: pos.speedAccuracy,
    );
  }

  PositionModel copyWith({
    double latitude,
    double longitude,
    DateTime timestamp,
    bool mocked,
    double altitude,
    double accuracy,
    double heading,
    double speed,
    double speedAccuracy,
  }) {
    return PositionModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      mocked: mocked ?? this.mocked,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'mocked': mocked,
      'altitude': altitude,
      'accuracy': accuracy,
      'heading': heading,
      'speed': speed,
      'speedAccuracy': speedAccuracy,
    };
  }

  factory PositionModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PositionModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      mocked: map['mocked'],
      altitude: map['altitude'],
      accuracy: map['accuracy'],
      heading: map['heading'],
      speed: map['speed'],
      speedAccuracy: map['speedAccuracy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PositionModel.fromJson(String source) =>
      PositionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PositionModel(latitude: $latitude, longitude: $longitude, timestamp: $timestamp, mocked: $mocked, altitude: $altitude, accuracy: $accuracy, heading: $heading, speed: $speed, speedAccuracy: $speedAccuracy)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PositionModel &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.timestamp == timestamp &&
        o.mocked == mocked &&
        o.altitude == altitude &&
        o.accuracy == accuracy &&
        o.heading == heading &&
        o.speed == speed &&
        o.speedAccuracy == speedAccuracy;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        timestamp.hashCode ^
        mocked.hashCode ^
        altitude.hashCode ^
        accuracy.hashCode ^
        heading.hashCode ^
        speed.hashCode ^
        speedAccuracy.hashCode;
  }
}
