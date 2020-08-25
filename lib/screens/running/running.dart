import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pulserun_app/bloc/running_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/models/plan.dart';
import 'package:pulserun_app/services/trackloc/trackloc.dart';

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
              BlocProvider.of<RunningBloc>(context).add(GetPlanAndStat());
              return LoadingWidget();
            } else if (state is RunningLoading) {
              return LoadingWidget();
            } else if (state is RunningLoaded) {
              return _buildbodyPlan(
                  context, state.currentStatusModel, state.planModel);
            } else if (state is RunningWorking) {
              return _buildbodyRunning(
                  context, state.positionModel, state.distance ?? 0);
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
                  context, state.positionModel, state.distance);
            } else if (state is RunningResult) {
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
        Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Text('Result'),
              ),
              Container(
                child: RaisedButton(
                  child: Text('Return to Home'),
                  onPressed: () {
                    BlocProvider.of<RunningBloc>(context).add(GetPlanAndStat());
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildbodyRunning(
      BuildContext context, PositionModel pos, double distance) {
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
                          Text('100 bpm'),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text('Timer'),
                          Text('0:0'),
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
                        BlocProvider.of<RunningBloc>(context)
                            .add(StartRunning());
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
