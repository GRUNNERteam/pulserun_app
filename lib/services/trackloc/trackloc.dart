import 'dart:async';

import 'package:location/location.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/repository/location_repository.dart';

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

  void uploadToDB() async {
    LocationRepository _temp = TestLocationDB();
    await _temp.uploadToDB(0, this._storage);
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
