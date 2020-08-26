import 'dart:convert';

class CurrentStatusModel {
  double bmi;
  String status;
  double distance;
  double weight;
  double height;
  CurrentStatusModel({
    this.bmi,
    this.status,
    this.distance,
    this.weight,
    this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'status': status,
      'distance': distance,
      'weight': weight,
      'height': height,
    };
  }

  factory CurrentStatusModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    // fix issue that firestore not support double
    if (map['bmi'] is int) {
      int temp = map['bmi'];
      map['bmi'] = temp.toDouble();
    }
    if (map['distance'] is int) {
      int temp = map['distance'];
      map['distance'] = temp.toDouble();
    }
    if (map['weight'] is int) {
      int temp = map['weight'];
      map['weight'] = temp.toDouble();
    }
    if (map['height'] is int) {
      int temp = map['height'];
      map['height'] = temp.toDouble();
    }

    return CurrentStatusModel(
      bmi: map['bmi'],
      status: map['status'],
      distance: map['distance'],
      weight: map['weight'],
      height: map['height'],
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
        o.distance == distance &&
        o.weight == weight &&
        o.height == height;
  }

  @override
  int get hashCode {
    return bmi.hashCode ^
        status.hashCode ^
        distance.hashCode ^
        weight.hashCode ^
        height.hashCode;
  }

  CurrentStatusModel copyWith({
    double bmi,
    String status,
    double distance,
    double weight,
    double height,
  }) {
    return CurrentStatusModel(
      bmi: bmi ?? this.bmi,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  @override
  String toString() {
    return 'CurrentStatusModel(bmi: $bmi, status: $status, distance: $distance, weight: $weight, height: $height)';
  }
}
