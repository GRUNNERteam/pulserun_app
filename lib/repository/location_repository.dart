abstract class LocationRepository {
  Future<void> uploadToDB();
}

class LocationData implements LocationRepository {
  @override
  Future<void> uploadToDB() {
    // TODO: implement uploadToDB
    throw UnimplementedError();
  }
}
