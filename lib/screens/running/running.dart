import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pulserun_app/bloc/running_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/screens/BLE/BLE.dart';
import 'package:logger/logger.dart';
import 'package:pulserun_app/screens/home/home.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:slider_button/slider_button.dart';
import 'package:getwidget/getwidget.dart';

BluetoothDevice currentdevice;
List<BluetoothService> service;
BluetoothService heartrate;
BluetoothCharacteristic characteristic;
HearRateModel heartRateModel = HearRateModel();

List<int> hr = List<int>.generate(10, (i) => i + 1);

var logger = Logger(
  printer: PrettyPrinter(),
);
var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class RunningPage extends StatefulWidget {
  const RunningPage({Key key}) : super(key: key);

  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  //TrackingLocationService _trackingLocationService = TrackingLocationService();
  GoogleMapController mapController;

  Map<PolylineId, Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  Map<MarkerId, Marker> _markers = {};

  void _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: _polylineCoordinates,
    );
    _polylines[id] = polyline;
  }

  void _onMapCreated(GoogleMapController googleMapController) async {
    mapController = googleMapController;
  }

  void _onMapCreatedReult(GoogleMapController googleMapController) async {
    mapController = googleMapController;

    await Future.delayed(Duration(seconds: 1)).then((_) {
      // https://stackoverflow.com/questions/61723113/flutter-latlngbounds-not-showing-accurate-place
      // fix latlngbounds

      // the bounds you want to set
      LatLngBounds bounds = LatLngBounds(
        southwest: _polylineCoordinates.last,
        northeast: _polylineCoordinates.first,
      );
      // calculating centre of the bounds
      LatLng centerBounds = LatLng(
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

      // setting map position to centre to start with
      mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: centerBounds,
        zoom: 17,
      )));
      zoomToFit(mapController, bounds, centerBounds);
    });
  }

  Future<void> zoomToFit(GoogleMapController controller, LatLngBounds bounds,
      LatLng centerBounds) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if (fits(bounds, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - 0.5;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  void _addMarker(LatLng position, String id,
      {BitmapDescriptor descriptor = BitmapDescriptor.defaultMarker}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(title: id),
    );
    _markers[markerId] = marker;
  }

  void _mapResult() {
    _addMarker(_polylineCoordinates.first, 'Start',
        descriptor: BitmapDescriptor.defaultMarkerWithHue(200));
    _addMarker(_polylineCoordinates.last, 'End');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<RunningBloc, RunningState>(
          builder: (context, state) {
            if (state is RunningInitial) {
              // syntax change
              // https://github.com/felangel/bloc/issues/603
              this._markers.clear();
              this._polylineCoordinates.clear();
              this._polylines.clear();
              BlocProvider.of<RunningBloc>(context).add(GetPlanAndStat());
              return LoadingWidget();
            } else if (state is RunningLoading) {
              return LoadingWidget();
            } else if (state is RunningLoaded) {
              heartRateModel.clear();
              this._markers.clear();
              this._polylineCoordinates.clear();
              this._polylines.clear();
              return _buildbodyPlan(
                  context, state.currentStatusModel, state.planModel);
            } else if (state is RunningWorking) {
              return _buildbodyRunning(
                  context,
                  state.positionModel,
                  state.distance ?? 0,
                  state.heartrate ?? 0,
                  state.targetheartrate);
            } else if (state is RunningDisplayChange) {
              if (state.positionModel != null) {
                try {
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      LocationModel().convertPosToCam(state.positionModel)));
                } catch (e) {
                  print('Pos not found : $e');
                }
              }
              _polylineCoordinates.add(LatLng(
                  state.positionModel.latitude, state.positionModel.longitude));
              _addPolyLine();
              // rebuild whole widget
              // https://github.com/felangel/bloc/issues/174#issuecomment-477867469
              return _buildbodyRunning(context, state.positionModel,
                  state.distance, state.hearrate, state.targetheartrate);
            } else if (state is RunningResult) {
              _mapResult();
              return _buildbodyResult(context, state.resultModel);
            } else {
              print('Error');
              return ShowErrorWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildbodyResult(BuildContext context, ResultModel resultModel) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      color: Colors.orangeAccent,
                      child: Container(
                        width: 400,
                        height: 50,
                        child: Column(
                          children: [
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(top: 13),
                              child: Text("Result",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    height: 150,
                    child: Row(
                      children: <Widget>[
                        Center(
                          child: Row(
                            children: [
                              Card(
                                child: Container(
                                  width: 121,
                                  height: 150,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.zoom_out_map,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text('Distance'),
                                      Container(
                                        padding: EdgeInsets.only(top: 13),
                                        child: Text(resultModel.totalDdistance
                                                .toStringAsFixed(3) +
                                            ' KM'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Container(
                                  width: 121,
                                  height: 150,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.healing,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text('AvgHeartRate'),
                                      Container(
                                        padding: EdgeInsets.only(top: 13),
                                        child: Text(resultModel.avgHearRate
                                                .toStringAsFixed(2) +
                                            ' BPM.'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Container(
                                  width: 121,
                                  height: 150,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.timer,
                                        ),
                                      ),
                                      Text('Time'),
                                      Container(
                                        padding: EdgeInsets.only(top: 13),
                                        child: Text(
                                            resultModel.totalTime.toString() +
                                                ' Min.'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: Colors.orangeAccent,
                          child: Container(
                            width: 400,
                            height: 50,
                            child: Column(
                              children: [
                                Center(
                                    child: Container(
                                  //padding: EdgeInsets.only(top: 5),
                                  child: Icon(
                                    Icons.map,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 400,
                          padding: EdgeInsets.all(8),
                          child: Flexible(
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _polylineCoordinates.last,
                                zoom: 20,
                              ),
                              onMapCreated: _onMapCreatedReult,
                              polylines: Set<Polyline>.of(_polylines.values),
                              markers: Set<Marker>.of(_markers.values),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                color: Color(0xff232d37)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 18.0, left: 12.0, top: 24, bottom: 12),
                              child: LineChart(
                                showAvg ? avgData() : mainData(resultModel),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 34,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                showAvg = !showAvg;
                              });
                            },
                            child: Text(
                              'avg',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: showAvg
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text('Return to Home'),
                      onPressed: () {
                        BlocProvider.of<RunningBloc>(context)
                            .add(GetPlanAndStat());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildbodyRunning(BuildContext context, PositionModel pos,
      double distance, int hr, int thr) {
    final RunningBloc bloc = BlocProvider.of<RunningBloc>(context);
    int value;
    String tZone = 'Loading';
    int check;
    double zone;
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 120,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: 120,
                              height: 85,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.zoom_out_map,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text((distance.toStringAsFixed(3) + ' KM') ??
                                      'Waiting'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: 120,
                              height: 85,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.healing,
                                      color: Colors.red,
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: characteristic.value,
                                    initialData: characteristic.lastValue,
                                    builder: (c, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text('Loading');
                                      } else if (snapshot.hasError)
                                        return Text('ERROR');
                                      else if (snapshot.data
                                              .toString()
                                              .split(',')
                                              .last
                                              .split(']')
                                              .first
                                              .toString() ==
                                          '[') {
                                        return Text(value.toString() + ' BPM');
                                      } else if (snapshot.hasData) {
                                        value = int.parse((snapshot.data
                                            .toString()
                                            .split(',')
                                            .last
                                            .split(']')
                                            .first
                                            .toString()));

                                        if (heartRateModel.heartRate.isEmpty) {
                                          loggerNoStack.i("message");
                                          heartRateModel.add_model(value);
                                        } else if (DateFormat.jms()
                                                .format(new DateTime.now()) !=
                                            DateFormat.jms().format(
                                                heartRateModel
                                                    .heartRate.last.time)) {
                                          heartRateModel.add_model(value);
                                        }
                                        return Text(value.toString() + ' BPM');
                                      }
                                      return Text(value.toString() + ' BPM');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: 120,
                              height: 85,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.timer,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  StreamBuilder<String>(
                                      stream: bloc.stopwatchTime,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData
                                            ? Text(snapshot.data)
                                            : Text('');
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: MediaQuery.of(context).size.height * .5,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.orangeAccent,
                    child: Container(
                      width: 400,
                      height: 50,
                      child: Column(
                        children: [
                          Center(
                            child: Icon(
                              Icons.map,
                              color: Colors.green,
                              size: 50,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  /*Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(
                    height: 10,
                  ),*/
                  Flexible(
                    child: GoogleMap(
                      initialCameraPosition:
                          LocationModel().convertPosToCam(pos),
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: _onMapCreated,
                      polylines: Set<Polyline>.of(this._polylines.values),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.blue,
                    child: Container(
                      width: 200,
                      height: 120,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.directions_run,
                            color: Colors.redAccent,
                            size: 50,
                          ),
                          Center(
                            child: Card(
                                child: Container(
                              width: 170,
                              height: 60,
                              child: Column(
                                children: [
                                  Center(
                                    heightFactor: 3.3,
                                    child: StreamBuilder(
                                      stream: characteristic.value,
                                      initialData: characteristic.lastValue,
                                      builder: (c, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text('Loading');
                                        } else if (snapshot.hasError)
                                          return Text('ERROR');
                                        else if (snapshot.data
                                                .toString()
                                                .split(',')
                                                .last
                                                .split(']')
                                                .first
                                                .toString() ==
                                            '[') {
                                          return Text(tZone);
                                        } else if (snapshot.hasData) {
                                          check = int.parse((snapshot.data
                                              .toString()
                                              .split(',')
                                              .last
                                              .split(']')
                                              .first
                                              .toString()));
                                          zone = (100 * check) / thr;
                                          if (zone >= 100) {
                                            tZone =
                                                'Dangerous slowdown or rest';
                                          } else if (zone >= 90 && zone < 100) {
                                            tZone = 'Zone 5';
                                          } else if (zone >= 80 && zone < 90) {
                                            tZone = 'Zone 4';
                                          } else if (zone >= 70 && zone < 80) {
                                            tZone = 'Zone 3';
                                          } else if (zone >= 60 && zone < 70) {
                                            tZone = 'Zone 2';
                                          } else if (zone >= 50 && zone < 60) {
                                            tZone = 'Zone 1';
                                          } else if (zone < 50) {
                                            tZone = 'Speed Up';
                                          } else
                                            tZone = 'Loading';

                                          return Text(tZone);
                                        }
                                        return Text("Loading");
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*Center(
                    child: Container(
                      color: Colors.blue[100],
                      padding: EdgeInsets.all(30.0),
                      child: StreamBuilder(
                        stream: characteristic.value,
                        initialData: characteristic.lastValue,
                        builder: (c, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('Loading');
                          } else if (snapshot.hasError)
                            return Text('ERROR');
                          else if (snapshot.data
                                  .toString()
                                  .split(',')
                                  .last
                                  .split(']')
                                  .first
                                  .toString() ==
                              '[') {
                            return Text(tZone);
                          } else if (snapshot.hasData) {
                            check = int.parse((snapshot.data
                                .toString()
                                .split(',')
                                .last
                                .split(']')
                                .first
                                .toString()));
                            zone = (100 * check) / thr;
                            if (zone >= 100) {
                              tZone = 'Dangerous slowdown or rest';
                            } else if (zone >= 90 && zone < 100) {
                              tZone = 'Zone 5';
                            } else if (zone >= 80 && zone < 90) {
                              tZone = 'Zone 4';
                            } else if (zone >= 70 && zone < 80) {
                              tZone = 'Zone 3';
                            } else if (zone >= 60 && zone < 70) {
                              tZone = 'Zone 2';
                            } else if (zone >= 50 && zone < 60) {
                              tZone = 'Zone 1';
                            } else if (zone < 50) {
                              tZone = 'Speed Up';
                            } else
                              tZone = 'Loading';

                            return Text(tZone);
                          }
                          return Text("Loading");
                        },
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SliderButton(
                      action: () {
                        BlocProvider.of<RunningBloc>(context)
                            .add(StopRunning());
                      },
                      label: Text(
                        "Slide to stop !",
                        style: TextStyle(
                            color: Color(0xff4a4a4a),
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      icon: Center(
                          child: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 40.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      )),

                      ///Change All the color and size from here.
                      width: 230,
                      radius: 10,
                      buttonColor: Color(0xffd60000),
                      backgroundColor: Color(0xFF000000),
                      highlightedColor: Colors.red,
                      baseColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildbodyPlan(
      BuildContext context, CurrentStatusModel stat, PlanModel plan) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0XFF00B686), Color(0XFF00838F)],
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Plan Infomation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Text('plan Id'),
                              Text(plan.planId.toString()),
                            ],
                          ),
                          Column(
                            children: [
                              Text('target hr'),
                              Text(plan.targetHeartRate.toString()),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Current BMI'),
                              Text(stat.bmi.toStringAsFixed(2)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Need To Run'),
                            Text('2 KM.'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 60),
                    height: 300,
                    width: 300,
                    child: RaisedButton(
                      color: Colors.red.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      onPressed: () {
                        if (currentdevice == null) {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              title: Text("Please Select Your Device"),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BLE()));
                                  },
                                  child: Text("Select Device"),
                                  isDefaultAction: true,
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("cancel"),
                              ),
                            ),
                          );
                        } else {
                          BlocProvider.of<RunningBloc>(context)
                              .add(StartRunning());
                        }
                      },
                      child: ColorizeAnimatedTextKit(
                        text: ["Start"],
                        textStyle: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: [
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                        ],
                        repeatForever: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  LineChartData mainData(ResultModel resultModel) {
    List<FlSpot> data = List<FlSpot>();
    List<int> hrList = List<int>();
    List<int> timeList = List<int>();
    data.clear();
    resultModel.totalHeartrate.heartRate.forEach((element) {
      data.add(FlSpot(element.hr.toDouble(), element.time.second.toDouble()));
      hrList.add(element.hr.toInt());
      timeList.add(element.time.second.toInt());
    });

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            /*for (int i = 0; i <= timeList.reduce(max); i++) {
              return i.toString();
            }*/
            return value.toString();
            /*switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return timeList.reduce(min).toString();*/
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            /* switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            */
            return hrList.reduce(min).toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: hrList.reduce(min).toDouble(),
      maxX: hrList.reduce(max).toDouble(),
      minY: timeList.reduce(min).toDouble(),
      maxY: timeList.reduce(max).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showAvg = false;

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'test';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
