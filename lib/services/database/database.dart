import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/models/user.dart';

class DatabaseService {
  // firestore
  // ignore: avoid_init_to_null
  String _uid = null;
  DatabaseService(BuildContext context) {
    var _user = Provider.of<UserModel>(context);
    this._uid = _user.getUid();
  }
}

class Push extends DatabaseService {
  Push(BuildContext context) : super(context);
}
