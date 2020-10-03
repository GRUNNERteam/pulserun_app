import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/screens/BLE/BLE.dart';
import 'package:pulserun_app/screens/home/components/dob_select.dart';
import 'package:pulserun_app/screens/home/components/heightweight_select.dart';
import 'package:pulserun_app/screens/home/components/history_card.dart';
import 'package:pulserun_app/screens/plan/plan.dart';
import 'package:pulserun_app/screens/running/running.dart';
import 'package:pulserun_app/screens/schedule/schedule.dart';
import 'package:pulserun_app/services/auth/auth.dart';

import '../../services/BLE_HeartRate/ble_heartrate.dart';

List<BluetoothService> services;
BluetoothDevice device;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _indexHotbar = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        if (state is HomeInitial) {
          BlocProvider.of<HomeCubit>(context).getUser(); // trigger to load data
          return LoadingWidget();
        } else if (state is HomeLoading) {
          return LoadingWidget();
        } else if (state is HomeRequestData) {
          if (state.userModel.birthDate == null) {
            return Scaffold(
              body: DoBSelectBox(),
            );
          }
          if (state.currentStatusModel.height == null ||
              state.currentStatusModel.weight == null) {
            return Scaffold(
              body: HeightWeightSelectBox(),
            );
          }
        } else if (state is HomeLoaded) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: _menu(),
            bottomNavigationBar: _buildBottomNavBar(index: _indexHotbar),
            body: _body(context, state.currentStatusModel, state.userModel),
          );
          //return _body(context, state.currentStatusModel, state.userModel);
        } else {
          // state Error
          return ShowErrorWidget();
        }
      }),
    );
  }

  Widget _body(
      BuildContext context, CurrentStatusModel status, UserModel user) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0XFF00B686), Color(0XFF00838F)]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                        FadeAnimatedTextKit(
                          text: [
                            'Wellcome to Fat Dash',
                            'Stay fit today',
                            'Run & Plan',
                          ],
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          repeatForever: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _profile(
                      displayname: user.displayName,
                      imgUrl: user.photoURL,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.grey.shade100,
                child: ListView(
                  padding: EdgeInsets.only(top: 45),
                  children: <Widget>[
                    Text(
                      "Device",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   child: StreamBuilder<List<BluetoothDevice>>(
                    //     stream: Stream.periodic(Duration(seconds: 5)).asyncMap(
                    //         (_) => FlutterBlue.instance.connectedDevices),
                    //     initialData: [],
                    //     builder: (c, snapshot) {
                    //       if (snapshot.hasData) {
                    //         return Column(
                    //           children: snapshot.data
                    //               .map(
                    //                 (d) => ListTile(
                    //                   title: Text(d.name),
                    //                   //subtitle: Text("connected"),
                    //                   subtitle:
                    //                       StreamBuilder<List<BluetoothService>>(
                    //                     stream: d.services,
                    //                     initialData: [],
                    //                     builder: (c, snapshot) {
                    //                       return Text(snapshot.data.toString());
                    //                     },
                    //                   ),
                    //                   trailing:
                    //                       StreamBuilder<BluetoothDeviceState>(
                    //                     stream: d.state,
                    //                     initialData:
                    //                         BluetoothDeviceState.disconnected,
                    //                     builder: (c, snapshot) {
                    //                       if (snapshot.data ==
                    //                           BluetoothDeviceState.connected) {
                    //                         return IconButton(
                    //                             icon: Icon(Icons.search),
                    //                             onPressed: () {
                    //                               d.discoverServices();
                    //                             });
                    //                       } else if (snapshot.data ==
                    //                           BluetoothDeviceState
                    //                               .disconnected) {
                    //                         return IconButton(
                    //                             icon: Icon(
                    //                                 Icons.bluetooth_disabled),
                    //                             onPressed: () {
                    //                               d.disconnect();
                    //                             });
                    //                       }
                    //                       return Text(snapshot.data.toString());
                    //                     },
                    //                   ),
                    //                 ),
                    //               )
                    //               .toList(),
                    //         );
                    //       } else {
                    //         return Column(
                    //           children: <Widget>[
                    //             Text('No device/Not Found'),
                    //           ],
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),

                    Text(
                      "Last 5 History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          historyCard(),
                          historyCard(),
                          historyCard(),
                          historyCard(),
                          historyCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        _status(
          bmi: status.bmi.toStringAsFixed(2),
          currentStatus: status.status.toString(),
          distance: status.distance.toString(),
        ),
      ],
    );
  }
}

class _buildBottomNavBar extends StatelessWidget {
  const _buildBottomNavBar({
    @required this.index,
    Key key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.floorPlan),
          title: Text("Current Plan"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.home),
          title: Text("HOME"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.runFast),
          title: Text("RUN"),
        ),
      ],
      currentIndex: index,
      onTap: (value) {
        switch (value) {
          case 0:
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     title: Text('Not Available'),
            //     content: const Text('Plan is not a available yet.'),
            //     actions: <Widget>[
            //       FlatButton(
            //         child: Text('Close'),
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //         },
            //       ),
            //     ],
            //   ),
            // );
            BlocProvider.of<PlanBloc>(context).add(GetPlanById());
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PlanPage()));

            break;
          case 2:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RunningPage()));
            break;
          default:
        }
      },
    );
  }
}

List<Widget> _buildServiceTiles(List<BluetoothService> services) {
  return services
      .map(
        (s) => ServiceTile(
          service: s,
          characteristicTiles: s.characteristics
              .map(
                (c) => CharacteristicTile(
                  onNotificationPressed: () async {
                    await c.setNotifyValue(!c.isNotifying);
                    await c.read();
                  },
                ),
              )
              .toList(),
        ),
      )
      .toList();
}

class _menu extends StatelessWidget {
  const _menu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    child: ColorizeAnimatedTextKit(
                      speed: Duration(milliseconds: 400),
                      text: ['FAT DASH'],
                      colors: [
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                        Colors.red,
                      ],
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      repeatForever: true,
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(MdiIcons.account),
            title: Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(MdiIcons.floorPlan),
            title: Text('Plan'),
            onTap: () {
              BlocProvider.of<PlanBloc>(context).add(GetPlanLists());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlanPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.calendar),
            title: Text('Schedule'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (SchedulePage())),
              );
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.history),
            title: Text('History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(MdiIcons.logout),
            title: Text('Sign out'),
            onTap: () async => await AuthService().signOutInstance(),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _profile extends StatelessWidget {
  final String displayname;
  final String imgUrl;
  const _profile({Key key, @required this.displayname, @required this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: Color(0XFF00B686),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 8,
                spreadRadius: 3,
              )
            ],
            border: Border.all(
              width: 1.5,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              imgUrl,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayname,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    MdiIcons.run,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "50 ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                              text: "km",
                              style: TextStyle(color: Colors.white38))
                        ]),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

// ignore: camel_case_types
class _status extends StatelessWidget {
  final String bmi;
  final String currentStatus;
  final String distance;

  const _status(
      {Key key,
      @required this.bmi,
      @required this.currentStatus,
      @required this.distance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 185,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        width: MediaQuery.of(context).size.width * 0.85,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              spreadRadius: 3,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          "BMI",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_upward,
                          color: Color(0XFF00838F),
                        )
                      ],
                    ),
                    Text(
                      bmi,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          "Status",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Color(0XFF00838F),
                        )
                      ],
                    ),
                    Text(
                      currentStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.grey),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Distance",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          MdiIcons.runFast,
                          color: Color(0XFF00838F),
                        )
                      ],
                    ),
                    Text(
                      double.parse(distance).toStringAsFixed(3) + " KM",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
