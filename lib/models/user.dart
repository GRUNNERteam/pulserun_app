import 'dart:convert';

class UserModel {
  final String uid;
  final String displayName;
  final String photoURL;
  final String email;
  String birthDate;
  final int targetHeartrate;

  UserModel(
    this.uid,
    this.displayName,
    this.photoURL,
    this.email,
    this.birthDate,
    this.targetHeartrate,
  );

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        photoURL.hashCode ^
        email.hashCode ^
        birthDate.hashCode ^
        targetHeartrate.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoURL': photoURL,
      'email': email,
      'birthDate': birthDate,
      'targetHeartrate': targetHeartrate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      map['uid'],
      map['displayName'],
      map['photoURL'],
      map['email'],
      map['birthDate'],
      map['targetHeartrate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String uid,
    String displayName,
    String photoURL,
    String email,
    String birthDate,
    int targetHeartrate,
  }) {
    return UserModel(
      uid ?? this.uid,
      displayName ?? this.displayName,
      photoURL ?? this.photoURL,
      email ?? this.email,
      birthDate ?? this.birthDate,
      targetHeartrate ?? this.targetHeartrate,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, photoURL: $photoURL, email: $email, birthDate: $birthDate, targetHeartrate: $targetHeartrate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.uid == uid &&
        o.displayName == displayName &&
        o.photoURL == photoURL &&
        o.email == email &&
        o.birthDate == birthDate &&
        o.targetHeartrate == targetHeartrate;
  }
}
