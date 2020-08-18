import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/services/auth/auth.dart';
import 'package:pulserun_app/services/database/database.dart';
import 'package:pulserun_app/theme/theme.dart';

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final AuthService _auth = AuthService();
  bool _isloading = true;
  DatabaseService _db = DatabaseService();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabcontroller;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: 2, vsync: this);
    _db.createAccount(widget.user);
    _isloading = false;
  }

  @override
  void dispose() {
    _tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.uid);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(),
              child: Text('Fat Dash'),
            ),
            ListTile(
              leading: Icon(MdiIcons.logout),
              title: Text('Sign out'),
              onTap: () => _auth.signOutInstance(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.floorPlan),
            title: Text('Planing'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.runFast),
            title: Text('Run'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: (_isloading)
          ? LoadingWidget()
          : Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0XFF00B686), Color(0XFF00838F)],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20.0, top: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      _scaffoldKey.currentState.openDrawer(),
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
                              displayname: widget.user.uid,
                            )
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
                          children: [
                            Text(
                              "Activity",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "History",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                _status()
              ],
            ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _profile extends StatelessWidget {
  final String displayname;
  const _profile({Key key, @required this.displayname}) : super(key: key);

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
          child: CircleAvatar(),
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

class _status extends StatelessWidget {
  const _status({
    Key key,
  }) : super(key: key);

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
            )),
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
                      children: [
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
                      "99",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black87),
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
                      children: [
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
                      "Unkown",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black87),
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
                          Icons.arrow_downward,
                          color: Color(0XFF00838F),
                        )
                      ],
                    ),
                    Text(
                      "0.1 km",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black87),
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

class HomePage extends StatefulWidget {
  final UserModel user;
  HomePage({Key key, @required this.user}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
