import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pulserun_app/bloc/plan_bloc.dart';
import 'package:pulserun_app/components/widgets/error_widget.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/cubit/home_cubit.dart';
import 'package:pulserun_app/models/currentstatus.dart';
import 'package:pulserun_app/models/result.dart';
import 'package:pulserun_app/models/running.dart';
import 'package:pulserun_app/models/schedule.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/repository/plan_repository.dart';
import 'package:pulserun_app/screens/BLE/BLE.dart';
import 'package:pulserun_app/screens/home/components/bottomcard_widget.dart';
import 'package:pulserun_app/screens/home/components/dob_select.dart';
import 'package:pulserun_app/screens/home/components/heightweight_select.dart';
import 'package:pulserun_app/screens/home/components/history_card.dart';
import 'package:pulserun_app/screens/home/components/today_schedule.dart';
import 'package:pulserun_app/screens/home/components/topcard_widget.dart';
import 'package:pulserun_app/screens/plan/plan.dart';
import 'package:pulserun_app/screens/running/running.dart';
import 'package:pulserun_app/screens/schedule/schedule.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:slimy_card/slimy_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _indexHotbar = 1;
  PlanRepository _planRepository;
  List<ResultModel> historyModel;

  Future<void> getHistory() async {
    List<DocumentReference> id = List<DocumentReference>();
    //id.clear();
    //historyModel = List<ResultModel>();
    //historyModel.clear();
    await _planRepository.setRef();
    DocumentReference ref = await _planRepository.getRef();
    await ref
        .collection('run')
        .orderBy('startTime', descending: true)
        .limit(5)
        .get()
        .then((collectionrun) {
      collectionrun.docs.forEach((element) async {
        loggerNoStack.i(RunningModel.fromMap(element.data()));
        id.add(element.reference);
      });
    });
    id = id.map((e) => e.collection('result').doc('result')).toList();
    historyModel = new List<ResultModel>(id.length);
    for (int i = 0; i < id.length; i++) {
      id[i].get().then((value) async {
        for (int j = 0; j < id.length; j++) {
          if (id[j].path.toString() == value.reference.path.toString()) {
            historyModel[j] = ResultModel.fromMap(value.data());
            loggerNoStack.i(historyModel.last.totalTime);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      print(state);
      loggerNoStack.i(state);
      if (state is HomeInitial) {
        BlocProvider.of<HomeCubit>(context).getUser(); // trigger to load data
        _planRepository = PlanData();
        historyModel = List<ResultModel>();
        getHistory();
        return LoadingWidget();
      } else if (state is HomeLoading) {
        getHistory();
        return LoadingWidget();
      } else if (state is HomeEmptyPlan) {
        return Scaffold(
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SlimyCard(
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width * 0.8,
                topCardHeight: 250,
                bottomCardHeight: 100,
                borderRadius: 15,
                topCardWidget: TopCardWidget(),
                bottomCardWidget: BottomCardWidget(),
                slimeEnabled: true,
              ),
            ),
          ),
        );
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
          body: _body(context, state.currentStatusModel, state.userModel,
              state.scheduleModel, historyModel),
        );
        //return _body(context, state.currentStatusModel, state.userModel);
      } else {
        // state Error
        return ShowErrorWidget();
      }
    });
  }

  Widget _body(BuildContext context, CurrentStatusModel status, UserModel user,
      ScheduleModel scheduleModel, List<ResultModel> historyModel) {
    List<historyCard> histoytCard = List<historyCard>();
    /*if (historyModel != null) {
      for (int i = 0; i < historyModel.length; i++) {
        histoytCard.add(historyCard(
          avgHeartrate:
              historyModel[i].avgHearRate.toStringAsFixed(2).toString(),
          distance:
              historyModel[i].totalDdistance.toStringAsFixed(2).toString(),
          time: historyModel[i].totalTime.toString(),
        ));
      }
    }*/
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
                      "ToDay".toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TodayScheduleReminder(
                      scheduleModel: scheduleModel,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Last 5 History".toUpperCase(),
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
                        children: histoytCard,
                        /* <Widget>[
                          /*historyCard(
                            avgHeartrate:
                                historyModel[0].avgHearRate.toString(),
                            distance: historyModel[0].totalDdistance.toString(),
                            time: historyModel[0].totalTime.toString(),
                          ),*/
                          /*historyCard(),
                          historyCard(),
                          historyCard(),
                          historyCard(),*/
                        ],*/
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
    return ConvexAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      activeColor: Theme.of(context).accentColor,
      style: TabStyle.fixedCircle,
      items: <TabItem>[
        TabItem(
          icon: Icon(
            MdiIcons.floorPlan,
            color: Colors.white,
          ),
          title: 'Current Plan',
        ),
        TabItem(
          icon: Icon(
            MdiIcons.home,
            color: Colors.white,
          ),
          title: 'HOME',
        ),
        TabItem(
          icon: Icon(
            MdiIcons.runFast,
            color: Colors.white,
          ),
          title: 'RUN',
        ),
      ],
      initialActiveIndex: index,
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
          case 1:
            BlocProvider.of<HomeCubit>(context).getUser();
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
            leading: Icon(MdiIcons.calendarToday),
            title: Text('Device'),
            onTap: () {
              BlocProvider.of<PlanBloc>(context).add(GetPlanLists());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BLE()),
              );
            },
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
