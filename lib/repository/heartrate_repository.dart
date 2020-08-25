import 'package:pulserun_app/models/heartrate.dart';

abstract class HeartRateRepository {
  Future<HeartRateModel> fetch();
}

class TestHeartRate implements HeartRateRepository {
  @override
  Future<HeartRateModel> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }
}
