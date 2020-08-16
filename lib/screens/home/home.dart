import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulserun_app/components/background/home_background.dart';
import 'package:pulserun_app/components/widgets/loading_widget.dart';
import 'package:pulserun_app/models/user.dart';
import 'package:pulserun_app/services/database/database.dart';
import 'package:pulserun_app/theme/theme.dart';

class _HomePageState extends State<HomePage> {
  bool _isloading = true;
  DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _db.createAccount(widget.user);
    _isloading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.uid);
    return Scaffold(
      body: (_isloading)
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Stack(
                children: [
                  HomePageBackground(
                    screenHeight: MediaQuery.of(context).size.height,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          height: 300.0,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Wellcome, ${widget.user.displayName}',
                                  style: TextStyle(
                                    color: GlobalTheme.default_text,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CircleAvatar(
                                  radius: 76,
                                  // TODO : backgroundColor will show green or red show current healthy
                                  backgroundColor: GlobalTheme.tiffany_blue,
                                  child: CircleAvatar(
                                    radius: 72,
                                    backgroundImage:
                                        (widget.user.imageURL != null)
                                            ? NetworkImage(widget.user.imageURL)
                                            : null,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 200,
                          child: Card(
                            color: GlobalTheme.light_cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            elevation: 0,
                          ),
                        )
                      ],
                    ),
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
