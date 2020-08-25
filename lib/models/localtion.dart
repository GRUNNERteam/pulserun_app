import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';

class LocationModel {
  List<PositionModel> position;
  List<googleMap.CameraPosition> camPosition;
  double totalDistance = 0;

  final latlong.Distance _distance = latlong.Distance();
  LocationModel({
    this.position,
    this.camPosition,
    this.totalDistance,
  });

  void addPos(PositionModel pos) {
    if (this.position == null) {
      this.position = List<PositionModel>();
      this.camPosition = List<googleMap.CameraPosition>();
      this.totalDistance = 0;
    }

    if (this.position.length > 1) {
      double temp = _distance.as(
        latlong.LengthUnit.Centimeter,
        latlong.LatLng(
            this.position.last.latitude, this.position.last.longitude),
        latlong.LatLng(pos.latitude, pos.longitude),
      );

      this.totalDistance = this.totalDistance + temp;
    }

    this.position.add(pos);
    this.camPosition.add(convertPosToCam(pos));
  }

  googleMap.CameraPosition convertPosToCam(PositionModel pos) {
    // ref MapView
    // https://developers.google.com/maps/documentation/android-sdk/views
    return googleMap.CameraPosition(
      target: googleMap.LatLng(pos.latitude, pos.longitude),
      bearing: pos.heading,
      tilt: 45,
      zoom: 20,
    );
  }

  LocationModel copyWith({
    List<PositionModel> position,
    List<googleMap.CameraPosition> camPosition,
    double totalDistance,
  }) {
    return LocationModel(
      position: position ?? this.position,
      camPosition: camPosition ?? this.camPosition,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Map<String, dynamic> toMap() {
    return {
      'position': position?.map((x) => x?.toMap())?.toList(),
      'camPosition': camPosition?.map((x) => x?.toMap())?.toList(),
      'totalDistance': totalDistance,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LocationModel(
      position: List<PositionModel>.from(
          map['position']?.map((x) => PositionModel.fromMap(x))),
      camPosition: List<googleMap.CameraPosition>.from(
          map['camPosition']?.map((x) => googleMap.CameraPosition.fromMap(x))),
      totalDistance: map['totalDistance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LocationModel(position: $position, camPosition: $camPosition, totalDistance: $totalDistance)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LocationModel &&
        listEquals(o.position, position) &&
        listEquals(o.camPosition, camPosition) &&
        o.totalDistance == totalDistance;
  }

  @override
  int get hashCode =>
      position.hashCode ^ camPosition.hashCode ^ totalDistance.hashCode;
}

class PositionModel {
  final double latitude;
  final double longitude;
  final double timestamp;
  final double altitude;
  final double accuracy;
  final double heading;
  final double speed;
  final double speedAccuracy;
  PositionModel({
    this.latitude,
    this.longitude,
    this.timestamp,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  PositionModel convertLocToPos(LocationData pos) {
    return PositionModel(
      latitude: pos.latitude,
      longitude: pos.longitude,
      timestamp: pos.time,
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
    double timestamp,
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
      'timestamp': timestamp,
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
      timestamp: map['timestamp'],
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
    return 'PositionModel(latitude: $latitude, longitude: $longitude, timestamp: $timestamp, altitude: $altitude, accuracy: $accuracy, heading: $heading, speed: $speed, speedAccuracy: $speedAccuracy)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PositionModel &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.timestamp == timestamp &&
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
        altitude.hashCode ^
        accuracy.hashCode ^
        heading.hashCode ^
        speed.hashCode ^
        speedAccuracy.hashCode;
  }
}
