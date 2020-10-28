import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/models/running.dart';

class historyCard extends StatelessWidget {
  final String time;
  final String distance;
  final String avgHeartrate;
  final ResultModel resultModel;
  final RunningModel runningModel;
  const historyCard({
    Key key,
    this.time,
    this.distance,
    this.avgHeartrate,
    this.resultModel,
    this.runningModel,
  }) : super(key: key);

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
              Text('Time: ' + this.time + " Min"),
              Text('Distance: ' + this.distance + " KM"),
              Text('Avg.HR: ' + this.avgHeartrate + " BPM"),
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: new Text('Details'),
                  content: ListView(
                    children: <Widget>[
                      // TODO: Add More Details
                      Text(resultModel.totalTime),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
