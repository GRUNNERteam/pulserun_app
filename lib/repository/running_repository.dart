import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/running.dart';

abstract class RunningRepository {
  Future<RunningModel> fetch(LocationModel loc, HeartRateModel hr);
}

class RunningData extends RunningRepository {
  @override
  Future<RunningModel> fetch(LocationModel loc, HeartRateModel hr) {
    // TODO: implement fetch
    throw UnimplementedError();
  }
}
