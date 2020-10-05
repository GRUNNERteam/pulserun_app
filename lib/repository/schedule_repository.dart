import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/schedule.dart';

abstract class ScheduleRespository {
  Future<ScheduleListModel> fetchLists();
  Future<ScheduleModel> fetch();

  Future<void> update(ScheduleModel scheduleModel);
  Future<void> create(ScheduleListModel listModel);

  // Ref
  Future<DocumentReference> getRef();

  Future<void> setRef(DocumentReference ref);
}

class ScheduleData implements ScheduleRespository {
  DocumentReference _documentReference;

  @override
  Future<void> create(ScheduleListModel listModel) async {
    try {
      await this._documentReference.set(listModel.toMap());
    } catch (err) {
      print('Error create schedule: $err');
    }
  }

  @override
  Future<ScheduleModel> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<ScheduleListModel> fetchLists() async {
    ScheduleListModel scheduleListModel;

    return scheduleListModel;
  }

  @override
  Future<void> update(ScheduleModel scheduleModel) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<DocumentReference> getRef() async {
    return await this._documentReference;
  }

  @override
  Future<void> setRef(DocumentReference ref) async {
    this._documentReference =
        ref.collection('scheduleCollection').doc('schedule');
  }
}
