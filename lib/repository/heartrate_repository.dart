import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/plan_repository.dart';

abstract class HeartRateRepository {
  Future<HeartRateModel> fetch();
  Future<void> insertdb(int hr);
}

class TestHeartRate implements HeartRateRepository {
  final PlanRepository _planRepository = MockUpPlan();
  DocumentReference _reference;
  RunningModel _runningModel;
  HeartRateModel _heartRateModel;

  @override
  Future<HeartRateModel> fetch() async {
    this._reference = await _planRepository.getRef(); //เอาแพลนไอดี
    this._reference = this._reference.collection('run').doc();
    this._reference = this._reference.collection(_runningModel.runId).doc();
    this._reference = this._reference.collection('heartrate').doc();
    throw UnimplementedError();
  }

  Future<void> insertdb(int hr) async {
    DateTime time = new DateTime.now();
    fetch();
    _heartRateModel.addItem(50, time);
    this._reference.set(_heartRateModel.toMap());
  }
}
