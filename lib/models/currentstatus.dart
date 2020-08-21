import 'package:flutter/material.dart';

class CurrentStatusModel extends ChangeNotifier {
  double _bmi;
  String _status;
  double _distance;

  double get bmi => _bmi;
  String get status => _status;
  double get distance => _distance;

  CurrentStatusModel() {
    // Mockup Data
    this._bmi = 0.0;
    this._status = 'Unknows';
    this._distance = 0.0;
  }
  Map<String, dynamic> getAllData() {
    print('Getting all CurrentStatus DataModel');
    return {
      'bmi': this._bmi,
      'status': this._status,
      'distance': this._distance,
    };
  }

  void setCurrentStatus(Map<String, dynamic> value) {
    value.forEach((key, value) {
      print('${key} : ${value}');
    });

    this._bmi = value['bmi'] as double;
    this._status = value['status'] as String;
    this._distance = value['distance'] as double;
    notifyListeners();
  }
}
