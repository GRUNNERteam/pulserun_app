import 'package:cloud_firestore/cloud_firestore.dart';

class HeartRateModel {
  List<HeartRateItem> hrList;

  void addItem(double value) {
    this.hrList.add(HeartRateItem(value));
  }
}

class HeartRateItem {
  double hr;
  Timestamp ts;

  HeartRateItem(double hr) {
    setHeartRate(hr);
  }

  void setHeartRate(double hr) {
    this.hr = hr;
    this.ts = Timestamp.now();
  }
}
