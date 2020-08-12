import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationItem {
  double lat;
  double lng;
  double alt;
  double bearing; // orientation aka heading in geolocator
  double tilt; // viewing angle
  DateTime ts; // timestamp

  LocationItem(this.lat, this.lng, this.alt, this.bearing, this.tilt, this.ts);
}

class LocationModel {
  List<LocationItem> locList; // new way to collect a location
  LatLng origin = new LatLng(0, 0);
  LatLng destination = new LatLng(0, 0);
  LatLng lastPos = new LatLng(0, 0);
  List<LatLng> _listPos = new List<LatLng>(); // will replace this with new list
  bool _allowToSave = true;

  // constructor
  LocationModel() {
    this._listPos.clear();
    this._allowToSave = true;
  }

  void clear() {
    this._listPos.clear();
    this.origin = LatLng(0, 0);
    this.destination = LatLng(0, 0);
    this.lastPos = LatLng(0, 0);
    this._allowToSave = true;
  }

  void addOrignLatLng(LatLng value) {
    try {
      // prevent add origin after add destination
      if (!_allowToSave) {
        // if origin was added should clear pos in list for tracking
        _listPos.clear();
        this.origin = value;
        addListLatLng(value);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void addDestination(LatLng value) {
    try {
      this.destination = value;
      addListLatLng(value);
      this._allowToSave = false;
    } catch (error) {
      print(error.toString());
    }
  }

  void addListLatLng(LatLng value) {
    try {
      // for debug
      if (_allowToSave) {
        print("LatLng : Lat=" +
            value.latitude.toString() +
            " Lng=" +
            value.longitude.toString());
        this._listPos.add(value);
        this.lastPos = value;
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void setLastPos(LatLng value) {
    this.lastPos = value;
  }

  LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  PointLatLng getLastPointLatLng() {
    return PointLatLng(lastPos.latitude, lastPos.longitude);
  }

  PointLatLng getOriginPointLatLng() {
    return PointLatLng(origin.latitude, origin.longitude);
  }
}
