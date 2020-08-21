import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/services/database/database.dart';

class RunningModel {
  int runId;
  List<RunningModelItem> runningItem;
  DocumentReference _runningRef;

  RunningModel() {
    this._runningRef = DatabaseService().getUserRef();
  }
}

class RunningModelItem {
  Timestamp startTime;
  Timestamp endTime;
  LocationModel tracking = null;
  HeartRateModel heartrate = null;

  RunningModelItem() {}
}
