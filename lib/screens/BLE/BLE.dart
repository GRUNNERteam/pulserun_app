import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pulserun_app/screens/running/running.dart';
import 'package:nice_button/nice_button.dart';

class BLE extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 5)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              currentdevice = device;

              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: Container(
        color: Colors.blueAccent[100],
        padding: EdgeInsets.all(60),
        child: Center(
          child: Column(
            children: [
              Text(device.name,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
              StreamBuilder<BluetoothDeviceState>(
                stream: device.state,
                builder: (context, snapshot) {
                  switch (snapshot.data) {
                    case BluetoothDeviceState.connected:
                      return Container(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Icon(
                              Icons.bluetooth_connected,
                              size: 250,
                              color: Colors.black,
                            ),
                          ));

                      break;
                    case BluetoothDeviceState.disconnected:
                      return Container(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Icon(
                              Icons.bluetooth_disabled,
                              size: 250,
                              color: Colors.black,
                            ),
                          ));
                      break;
                    default:
                      break;
                  }
                },
              ),
              StreamBuilder<BluetoothDeviceState>(
                stream: device.state,
                builder: (context, snapshot) {
                  switch (snapshot.data) {
                    case BluetoothDeviceState.connected:
                      return Container(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                        child: RaisedButton(
                          onPressed: () {
                            discover();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RunningPage()),
                            );
                          },
                          color: Colors.lightGreenAccent,
                          child: Text(
                            'RUN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 90,
                            ),
                          ),
                        ),
                      );
                      break;

                    default:
                      return Container(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                        child: RaisedButton(
                          onPressed: null,
                          color: Colors.lightGreenAccent,
                          child: Text(
                            'RUN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 90,
                            ),
                          ),
                        ),
                      );
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Text(
          'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
          style: Theme.of(context)
              .primaryTextTheme
              .subhead
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

// ignore: missing_return
Future<bool> discover() async {
  service = await currentdevice.discoverServices();
  currentdevice.services.forEach((service) {
    service.forEach((c) {
      if (c.uuid.toString().toUpperCase().substring(4, 8) == "180D") {
        c.characteristics.forEach((element) async {
          if (element.uuid.toString().toUpperCase().substring(4, 8) == "2A37") {
            characteristic = element;
            await characteristic.setNotifyValue(!characteristic.isNotifying);
            return true;
          }
        });
      }
    });
  });
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      leading: Icon(Icons.watch),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
    );
  }
}
