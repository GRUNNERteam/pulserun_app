import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _uid;
  String _displayName;
  String _photoURL;
  String _email;
  String _birthDate;

  String get uid => _uid;
  String get displayName => _displayName;
  String get photoURL => _photoURL;
  String get email => _email;
  String get birthDate => _birthDate;
  // Constructor

  void setUserModel(User user) {
    this._uid = user.uid;
    this._displayName = user.displayName;
    this._photoURL = user.photoURL;
    this._email = user.email;
    notifyListeners();
  }

  void setBirthDate(String value) {
    // https://stackoverflow.com/questions/57494106/how-to-select-birth-date-with-dateformat-in-flutter
    try {} catch (e) {}
  }

  void setAllData(Map<String, dynamic> value) {
    print('SetData to UserModel');
    // value.forEach((key, value) {
    //   print('${key} : ${value}');
    // });
    this._uid = value['uid'];
    this._displayName = value['displayName'];
    this._photoURL = value['photoURL'] ?? '';
    this._email = value['email'];
    this._birthDate = value['birthDate'] ?? '';

    notifyListeners();
  }

  String getUid() {
    return this.isEmpty() ? null : this.uid.toString();
  }

  bool isEmpty() {
    if (this.uid == null) {
      return true;
    }
    return false;
  }

  bool isBirthDateEmpty() {
    if (this._birthDate == null || this._birthDate == '') {
      print('BirthDate is Empty');
      return true;
    } else {
      print(this._birthDate);
      return false;
    }
  }

  Map<String, dynamic> getAllUserData() {
    print('Getting all User DataModel');
    return {
      'uid': this._uid,
      'email': this._email,
      'displayName': this._displayName,
      'photoURL': this._photoURL,
      'birthDate': this._birthDate,
      //'statistic': statistic.getAllData(),
    };
  }
}
