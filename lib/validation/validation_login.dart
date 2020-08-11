import 'package:flutter/material.dart';
import 'validation_model.dart';

class ValidationLogin extends ChangeNotifier {
  ValidationItem _username = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  ValidationItem get username => _username;
  ValidationItem get password => _password;

  void changeUsername(String value) {
    if (value.isEmpty) {
      _username = ValidationItem(null, "Please Enter an username");
    } else {
      _username = ValidationItem(value, null);
    }
    notifyListeners();
  }

  void changePassword(String value) {
    if (value.isEmpty) {
      _password = ValidationItem(null, "Please Enter an password");
    } else {
      _password = ValidationItem(value, null);
    }
    notifyListeners();
  }
}
