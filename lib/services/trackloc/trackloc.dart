import 'package:geolocator/geolocator.dart';
import 'package:pulserun_app/models/localtion.dart';

class TrackingLocationService {
  final Geolocator _geolocator = Geolocator();

  LocationModel storage;
  bool _hasPermission = false;

  TrackingLocationService() {}

  void init() async {
    Position pos = await _geolocator.getCurrentPosition();
    this.storage = LocationModel(position: PositionModel.;
  }
}
