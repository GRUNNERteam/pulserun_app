import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/services/generates/generate_schedule.dart';

abstract class ScheduleRespository {
  Future<ScheduleListModel> fetchLists();
  Future<ScheduleModel> fetch();

  Future<void> update(ScheduleModel scheduleModel);
  Future<void> create();

  // Ref
  Future<CollectionReference> getRef();

  Future<void> setRef(DocumentReference ref);
  Future<void> setPlanModel(PlanModel plan);
}

class ScheduleData implements ScheduleRespository {
  List<DocumentReference> _documentReference = [];
  CollectionReference _collectionReference;
  ScheduleListModel _scheduleListModel;
  ScheduleModel _scheduleModel;
  ScheduleGoalModel _scheduleGoalModel;
  PlanModel _plan;

  @override
  Future<void> create() async {
    if (this._plan == null) {
      print('ScheduleRespository : _plan is null');
      return;
    }

    if (this._collectionReference == null) {
      print('ScheduleRespository : _collectionReference is null');
      return;
    }

    ScheduleListModel lists =
        await GenerateScheduleService().generateScheduleWeekly(this._plan);

    lists.scheduleList.forEach((element) {
      try {
        this._collectionReference.doc().set(element.toMap());
      } catch (e) {
        print('Error createing schedule to DB : $e');
      }
    });
  }

  @override
  Future<ScheduleModel> fetch() async {
    ScheduleModel scheduleModel;

    // fetch CurrentDay

    // where search in firebase
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    final DateTime start = DateTime.parse(formatted);
    final DateTime end = DateTime.parse(formatted).add(Duration(days: 1));

    await this
        ._collectionReference
        .where(
          'ts',
          isGreaterThanOrEqualTo: Timestamp.fromMillisecondsSinceEpoch(
            start.millisecondsSinceEpoch,
          ),
        )
        .where(
          'ts',
          isLessThan: Timestamp.fromMillisecondsSinceEpoch(
            end.millisecondsSinceEpoch,
          ),
        )
        .orderBy('ts')
        .limit(1)
        .get()
        .then((collectionSnapShot) {
          // collectionSnapShot.docs.forEach((element) {
          //   element.data().forEach((key, value) {
          //     print('key : $key | value : $value');
          //   });
          // });
          if (collectionSnapShot.size > 0) {
            scheduleModel =
                ScheduleModel.fromMap(collectionSnapShot.docs.first.data());
          }
        })
        .then(
          (_) => print('Fetch today schedule is done'),
        )
        .catchError(
          (err) => print('Fetch today schedule ERROR : $err'),
        );

    return scheduleModel;
  }

  @override
  Future<ScheduleListModel> fetchLists() async {
    if (this._collectionReference == null) {
      print('ScheduleRespository : _collectionReference is null');
      return null;
    }

    ScheduleListModel scheduleListModel;
    List<ScheduleModel> lists = [];

    await this._collectionReference.get().then((docSnapShot) {
      if (docSnapShot.size > 0) {
        docSnapShot.docs.forEach((snapShot) {
          lists.add(ScheduleModel.fromMap(snapShot.data()));
        });
      }
    });

    scheduleListModel = ScheduleListModel(scheduleList: lists);
    return scheduleListModel;
  }

  @override
  Future<void> update(ScheduleModel scheduleModel) async {
    // update current schedule
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    final DateTime start = DateTime.parse(formatted);
    final DateTime end = DateTime.parse(formatted).add(Duration(days: 1));

    await this
        ._collectionReference
        .where(
          'ts',
          isGreaterThanOrEqualTo: Timestamp.fromMillisecondsSinceEpoch(
            start.millisecondsSinceEpoch,
          ),
        )
        .where(
          'ts',
          isLessThan: Timestamp.fromMillisecondsSinceEpoch(
            end.millisecondsSinceEpoch,
          ),
        )
        .orderBy('ts')
        .limit(1)
        .get()
        .then((collectionSnapShot) async {
          if (collectionSnapShot.size > 0) {
            await collectionSnapShot.docs.first.reference.update(
              scheduleModel.toMap(),
            );
          } else {
            print('Not found schedule');
          }
        })
        .then(
          (_) => print('Update today schedule is done'),
        )
        .catchError(
          (err) => print('Update today schedule ERROR : $err'),
        );
  }

  @override
  Future<CollectionReference> getRef() async {
    return await this._collectionReference;
  }

  @override
  Future<void> setRef(DocumentReference ref) async {
    this._collectionReference = ref.collection('schedule');
  }

  @override
  Future<void> setPlanModel(PlanModel plan) async {
    this._plan = plan;
  }
}
