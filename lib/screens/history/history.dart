import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/models/running.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<ResultModel>> _loadResult() async {
    CurrentStatusModel currentStatusModel = CurrentStatusModel();

    DocumentReference planRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('stat')
        .doc('current');

    await planRef.get().then((snapshot) {
      if (snapshot.exists) {
        currentStatusModel = CurrentStatusModel.fromMap(snapshot.data());
      }
    });

    List<ResultModel> reultLists = [];
    List<RunningModel> runningLists = [];
    List<LocationModel> locationLists = [];
    List<HearRateModel> heartRateLists = [];

    List<DocumentReference> docRefs = [];

    if (currentStatusModel.planRef != null) {
      await currentStatusModel.planRef
          .collection('run')
          .orderBy('startTime', descending: true)
          .get()
          .then((collection) {
        if (collection.size > 0) {
          for (QueryDocumentSnapshot doc in collection.docs) {
            if (doc.exists) {
              docRefs.add(doc.reference);
              runningLists.add(RunningModel.fromMap(doc.data()));
            }
          }
        }
      });
    }

    if (docRefs.isNotEmpty) {
      for (DocumentReference ref in docRefs) {
        await ref.collection('');
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
          } else {
            return Text('No History');
          }
        },
      ),
    );
  }
}
