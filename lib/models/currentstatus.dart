import 'dart:convert';

class CurrentStatusModel {
  double bmi;
  String status;
  double distance;
  CurrentStatusModel({
    this.bmi,
    this.status,
    this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'status': status,
      'distance': distance,
    };
  }

  factory CurrentStatusModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    if (map['bmi'] is int) {
      int temp = map['bmi'];
      map['bmi'] = temp.toDouble();
    }
    if (map['distance'] is int) {
      int temp = map['distance'];
      map['distance'] = temp.toDouble();
    }
    return CurrentStatusModel(
      bmi: map['bmi'] as double,
      status: map['status'] as String,
      distance: map['distance'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentStatusModel.fromJson(String source) =>
      CurrentStatusModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentStatusModel &&
        o.bmi == bmi &&
        o.status == status &&
        o.distance == distance;
  }

  @override
  int get hashCode => bmi.hashCode ^ status.hashCode ^ distance.hashCode;
}
