import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  LatLng origin = new LatLng(0, 0);
  LatLng destination = new LatLng(0, 0);
  LatLng lastPos = new LatLng(0, 0);
  List<LatLng> _listPos = new List<LatLng>();
  bool _allowToSave = true;
  LocationModel() {
    _listPos.clear();
    _allowToSave = true;
  }

  void addOrignLatLng(LatLng value) {
    // prevent add origin after add destination
    if (!_allowToSave) return;

    try {
      // if origin was added should clear pos in list for tracking
      _listPos.clear();
      this.origin = value;
      addListLatLng(value);
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
    if (!_allowToSave) return;

    try {
      // for debug
      print("LatLng : Lat=" +
          value.latitude.toString() +
          " Lng=" +
          value.longitude.toString());
      this._listPos.add(value);
      this.lastPos = value;
    } catch (error) {
      print(error.toString());
    }
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
