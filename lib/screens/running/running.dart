import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pulserun_app/bloc/running_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/heartrate.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/repository/heartrate_repository.dart';
import 'package:pulserun_app/screens/BLE/BLE.dart';
import 'package:logger/logger.dart';
import 'package:pulserun_app/screens/home/home.dart';

BluetoothDevice currentdevice;
List<BluetoothService> service;
BluetoothService heartrate;
BluetoothCharacteristic characteristic;
List<int> hr = [0];

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
              this._markers.clear();
              this._polylineCoordinates.clear();
              this._polylines.clear();
              return _buildbodyPlan(
                  context, state.currentStatusModel, state.planModel);
            } else if (state is RunningWorking) {
              return _buildbodyRunning(context, state.positionModel,
                  state.distance ?? 0, state.heartrate ?? 0);
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
              return _buildbodyRunning(
                  context, state.positionModel, state.distance, state.hearrate);
            } else if (state is RunningResult) {
              _mapResult();
              return _buildbodyResult(context);
            } else {
              print('Error');
              return ShowErrorWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildbodyResult(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text('Result'),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    height: 150,
                    child: Row(
                      children: <Widget>[],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text('Location'),
                        Container(
                          height: 1,
                          color: Colors.grey,
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

  Widget _buildbodyRunning(
      BuildContext context, PositionModel pos, double distance, int hr) {
    final RunningBloc bloc = BlocProvider.of<RunningBloc>(context);
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
                          Text('Current Distance'),
                          Text((distance.toString() + ' KM') ?? 'Waiting'),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text('Current HeartRate'),
                          // TODO : change to Real-Time Heart Rate
                          StreamBuilder(
                            stream: characteristic.value,
                            initialData: characteristic.lastValue,
                            builder: (c, snapshot) {
                              int value;
                              loggerNoStack.i(snapshot.data.toString());
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
                                value = 0;
                                return Text(value.toString());
                              } else if (snapshot.hasData) {
                                value = int.parse((snapshot.data
                                    .toString()
                                    .split(',')
                                    .last
                                    .split(']')
                                    .first
                                    .toString()));
                                return Text(value.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text('Timer'),
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
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * .5,
              child: Column(
                children: <Widget>[
                  Text(
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
                  ),
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
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Stop'),
                      onPressed: () {
                        BlocProvider.of<RunningBloc>(context)
                            .add(StopRunning());
                      },
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
                              Text(stat.bmi.toString()),
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
}
