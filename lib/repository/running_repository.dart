import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/currentstatus_repository.dart';
import 'package:pulserun_app/repository/heartrate_repository.dart';
import 'package:pulserun_app/repository/location_repository.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/repository/result_repository.dart';
import 'package:pulserun_app/screens/running/running.dart';

String idR;

abstract class RunningRepository {
  Future<RunningModel> fetch(LocationModel loc);

  Future<void> init();
  Future<double> working(PositionModel pos);
  Future<RunningModel> stop();
  Future<void> setestimatedTime(String et);
  DocumentReference gettReference();
}

class RunningData extends RunningRepository {
  /// ###Important Note### : Change Repostioy before production(Corrent reps)
  final PlanRepository _planRepository = PlanData();
  final LocationRepository _locationRepository = LocationServiceAndTracking();
  final CurrentStatusRepository _currentStatusRepository = CurrentStatus();
  final HeartRateRepository _heartRateRepository = TestHeartRate();
  final ResultRepository _resultRepository = Result();
  RunningModel _runningModel;
  DocumentReference _reference;
  HearRateModel hrm = HearRateModel();
  RunningModel hrtd = RunningModel();

  DateTime startTime;

  @override
  Future<RunningModel> fetch(LocationModel loc) async {
    throw UnimplementedError();
  }

  DocumentReference gettReference() {
    return this._reference;
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
    await _planRepository.setRef();
    this._reference = await _planRepository.getRef();
    this._reference = this._reference.collection('run').doc();
    this._runningModel =
        RunningModel(runId: this._reference.id, startTime: DateTime.now());
    await this._reference.set(this._runningModel.toMap());
    loggerNoStack.i(this._reference.path.toString());
    // Location
    this
        ._locationRepository
        .setRef(this._reference.collection('location').doc());

    this._locationRepository.setService();
  }

  @override
  Future<RunningModel> stop() async {
    final double disT = await this._locationRepository.getDistance();
    await this._heartRateRepository.init(this._reference);
    await this._heartRateRepository.addDB();
    await this._runningModel.setendTime();
    await this._runningModel.updateDistance(disT);
    await this._reference.update({'distance': disT});
    await this._reference.update(this._runningModel.toMap());
    await this._currentStatusRepository.updateDistance(disT);
    await this._locationRepository.uploadToDB();
    await this
        ._reference
        .collection('heartrate')
        .doc('heartrate')
        .get()
        .then((snapshot) async {
      this.hrm = HearRateModel.fromMap(snapshot.data());
      await this._resultRepository.getHR(this.hrm);
      /*this.hrm.heartRate.forEach((element) async {
        await _resultRepository.getHR(this.hrm);
      });*/
    });
    double avgHR = 0;
    this.hrm.heartRate.forEach((element) {
      avgHR = avgHR + element.hr;
    });
    avgHR = avgHR / this.hrm.heartRate.length;
    await this._reference.get().then((snapshot) async {
      this.hrtd = RunningModel.fromMap(snapshot.data());
      await this
          ._resultRepository
          .getDistime(this.hrtd.distance, this.hrtd.estimatedTime, avgHR);
      loggerNoStack.i(this.hrtd.distance.toString(), "TEST");
    });
    await this._resultRepository.upDB(this._reference);
    loggerNoStack.i(this._reference.path.toString());
    return this._runningModel;
  }

  @override
  Future<void> setestimatedTime(String et) async {
    this._runningModel.estimatedTime = et;
  }
}
