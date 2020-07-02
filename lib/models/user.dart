class UserModel {
  String uid;
  String displayName;
  String imageURL;

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
}
