import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/screens/running/running.dart';

abstract class ResultRepository {
  Future<void> getHR(HearRateModel hrModel);
  Future<void> getDistime(double dis, String time);
  Future<void> upDB(DocumentReference ref);
  Future<void> setRef(DocumentReference ref);
  Future<ResultModel> getResult();
}

class Result implements ResultRepository {
  DocumentReference _reference;

  ResultModel _resultModel;

  Future<void> getHR(HearRateModel hrModel) async {
    if (this._resultModel == null) {
      this._resultModel = ResultModel();
    }
    if (this._resultModel.totalHeartrate == null) {
      loggerNoStack.i('null');
      this._resultModel.totalHeartrate = HearRateModel();
    }
    if (this._resultModel.totalHeartrate == null) {
      this._resultModel.totalHeartrate = hrModel;
    }
    this._resultModel.totalHeartrate = hrModel;
  }

  Future<void> getDistime(double dis, String time) async {
    if (this._resultModel == null) {
      this._resultModel = ResultModel();
    }
    this._resultModel.totalDdistance = dis;
    this._resultModel.totalTime = time;
  }

  Future<void> upDB(DocumentReference ref) async {
    ref.collection('result').doc('result').set(this._resultModel.toMap());
  }

  Future<void> setRef(DocumentReference ref) async {
    this._reference = ref;

    this._reference = this._reference.collection('result').doc('result');
  }

  Future<ResultModel> getResult() async {
    await this._reference.get().then((snapshot) {
      this._resultModel = ResultModel.fromMap(snapshot.data());
    });
    return this._resultModel;
  }
}
