import 'dart:async';

import 'package:location/location.dart';
import 'package:pulserun_app/models/localtion.dart';

class TrackingLocationService {
  LocationModel _storage;

  void addToList(PositionModel pos) {
    if (_storage == null) {
      this._storage = LocationModel();
      this._storage.addPos(pos);
    } else {
      this._storage.addPos(pos);
    }
  }

  void cleanData() async {
    this._storage = null;
  }

  double distanceCentToKM() {
    return (this._storage.totalDistance / 100000) ?? 0.0;
  }

  LocationModel getData() {
    return this._storage;
  }
}

class LocationService {
  PositionModel _currentPos;
  final Location _location = Location();
  StreamController<PositionModel> _locationController =
      StreamController<PositionModel>.broadcast();

  LocationService() {
    _location.requestPermission().then((granded) {
      if (granded == PermissionStatus.granted) {
        _location.onLocationChanged.listen((data) {
          if (data != null) {
            _locationController.add(PositionModel().convertLocToPos(data));
          }
        });
      }
    });
  }

  Future<PositionModel> getLocation() async {
    try {
      LocationData pos = await _location.getLocation();
      this._currentPos = PositionModel().convertLocToPos(pos);
    } catch (e) {
      print('Can not getLocation : $e');
    }
    return this._currentPos;
  }
}
