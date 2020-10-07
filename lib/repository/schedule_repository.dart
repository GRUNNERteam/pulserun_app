import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulserun_app/models/schedule.dart';

abstract class ScheduleRespository {
  Future<ScheduleListModel> fetchLists();
  Future<ScheduleModel> fetch();

  Future<void> update(ScheduleModel scheduleModel);
  Future<void> create(ScheduleListModel listModel);

  // Ref
  Future<CollectionReference> getRef();

  Future<void> setRef(DocumentReference ref);
}

class ScheduleData implements ScheduleRespository {
  List<DocumentReference> _documentReference = [];
  CollectionReference _collectionReference;
  ScheduleListModel _scheduleListModel;
  ScheduleModel _scheduleModel;
  ScheduleGoalModel _scheduleGoalModel;
  List<ScheduleGoalModel> _goalList;

  @override
  Future<void> create(ScheduleListModel listModel) async {
    if (this._scheduleListModel == null || this._collectionReference == null) {
      return;
    }

    // prepare the data
    // update ref
    await this._scheduleListModel.scheduleList.forEach((schedule) async {
      this._documentReference.add(
          _collectionReference.doc(schedule.events.values.first.toString()));

      try {
        await this._documentReference.last.set(schedule.toMap());
        await this._documentReference.last.collection('goal').doc();
      } catch (err) {
        print('Error create schedule: $err');
      }
    });
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
  Future<CollectionReference> getRef() async {
    return await this._collectionReference;
  }

  @override
  Future<void> setRef(DocumentReference ref) async {
    this._collectionReference = ref.collection('schedule');
  }
}
