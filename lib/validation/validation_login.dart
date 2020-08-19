import 'package:flutter/material.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'validation_model.dart';

class ValidationLogin extends ChangeNotifier {
  final _auth = new AuthService();

  ValidationItem _username = new ValidationItem(null, null);
  ValidationItem _password = new ValidationItem(null, null);

  ValidationItem get username => _username;
  ValidationItem get password => _password;
  bool get isValid {
    if (_username.value != null && _password.value != null) {
      return true;
    } else {
      return false;
    }
  }

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

  void submit() {
    //_auth.signInWithEmailAndPassword(_username.value, _password.value);
  }
}
