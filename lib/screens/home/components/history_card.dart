import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
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
      margin: EdgeInsets.all(8),
      height: 200,
      width: 200,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Text('Time'),
              Text('Distance'),
              Text('Avg.Heartrate'),
              Text('Status'),
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text('More details'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
