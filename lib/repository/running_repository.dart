import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/heartrate_repository.dart';
import 'package:pulserun_app/repository/location_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';

abstract class RunningRepository {
  Future<RunningModel> fetch(LocationModel loc, HeartRateModel hr);

  Future<void> init();
  Future<double> working(PositionModel pos);
  Future<RunningModel> stop();
  Future<void> setestimatedTime(String et);
}

class RunningData extends RunningRepository {
  final PlanRepository _planRepository = PlanData();
  final LocationRepository _locationRepository = LocationServiceAndTracking();
  final CurrentStatusRepository _currentStatusRepository = CurrentStatus();
  final HeartRateRepository _heartRateRepository = TestHeartRate();
  RunningModel _runningModel;
  DocumentReference _reference;

  DateTime startTime;

  @override
  Future<RunningModel> fetch(LocationModel loc, HeartRateModel hr) async {
    throw UnimplementedError();
  }

  @override
  Future<double> working(PositionModel pos) async {
    await this._locationRepository.setPos(pos);
    double distance = await this._locationRepository.getDistance();
    return distance;
  }

  @override
  Future<void> init() async {
    this._runningModel = null;
    this._reference = await _planRepository.getRef();
    this._reference = this._reference.collection('run').doc();
    this._runningModel =
        RunningModel(runId: this._reference.id, startTime: DateTime.now());

    await this._reference.set(this._runningModel.toMap());

    // Location
    this
        ._locationRepository
        .setRef(this._reference.collection('location').doc());

    this._locationRepository.setService();
  }

  @override
  Future<RunningModel> stop() async {
    await this._runningModel.setendTime();
    await this._reference.update(this._runningModel.toMap());
    final double disT = await this._locationRepository.getDistance();
    await this._currentStatusRepository.updateDistance(disT);
    await this._locationRepository.uploadToDB();
    return this._runningModel;
  }

  @override
  Future<void> setestimatedTime(String et) async {
    this._runningModel.estimatedTime = et;
  }
}
