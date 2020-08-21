import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowErrorWidget extends StatelessWidget {
  const ShowErrorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        SpinKitDoubleBounce(
          size: 150.0,
          color: Colors.redAccent,
        ),
        Center(
          child: Container(
            child: Text(
              'Something went wrong please try again',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
