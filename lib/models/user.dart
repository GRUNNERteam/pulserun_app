class UserModel {
  String uid;
  String displayName;
  String imageURL;
  Map<String, dynamic> statistic = {};
  // Constructor
  UserModel({this.uid, this.displayName, this.imageURL});
  String getUid() {
    return this.isEmpty() ? null : this.uid.toString();
  }

  bool isEmpty() {
    if (this.uid == null) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> getAllUserData() {
    return {
      "uid": uid,
      "displayName": displayName,
      "imageURL": imageURL,
    };
  }
}
