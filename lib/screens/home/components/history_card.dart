import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class historyCard extends StatelessWidget {
  final String time;
  final String distance;
  final String avgHeartrate;
  final String status;
  final DocumentReference ref;

  const historyCard(
      {Key key,
      this.time,
      this.distance,
      this.avgHeartrate,
      this.status,
      this.ref})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Text('Time'),
              Text('Distance'),
              Text('Avg.Heartrate'),
              Text('Status'),
              Expanded(
                child: RaisedButton(
                  child: Text('View'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
