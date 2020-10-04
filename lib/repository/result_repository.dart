import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/screens/running/running.dart';

abstract class ResultRepository {
  Future<void> init(
      DocumentReference getreference, RunningModel _runningModel, double disT);
  Future<void> getResult();
}

class Result implements ResultRepository {
  DocumentReference _reference;
  final PlanRepository _planRepository = PlanData();
  ResultModel _resultModel;

  Future<void> init(DocumentReference getreference, RunningModel _runningModel,
      double disT) async {
    this._reference = await _planRepository.getRef();

    final countTime = _runningModel.endTime.difference(_runningModel.startTime);
    this._resultModel.totalTime = countTime.toString();
    this._resultModel.totalDdistance = disT;
    this._resultModel.totalHeartrate = heartRateModel;
    this
        ._reference
        .collection('Result')
        .doc('Result')
        .set(this._resultModel.toMap());
  }

  Future<void> getResult() async {}
}
