import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  // ignore: avoid_init_to_null
  LatLng lastPos = null;
  List<LatLng> _listPos = new List<LatLng>();
  LocationModel() {
    _listPos.clear();
  }

  void addListLatLng(LatLng value) {
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
}
