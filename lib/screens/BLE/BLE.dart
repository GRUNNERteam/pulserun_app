import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pulserun_app/screens/running/running.dart';
import 'package:pulserun_app/services/ble_heartrate/ble_heartrate.dart';

import '../home/home.dart';

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
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 3))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () {
                                      //discover(d);
                                      currentdevice = d;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceScreen(device: d)));
                                    },
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
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
                            //discover(r.device);
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

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  @override
  Widget build(BuildContext context) {
    discover(device);
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          //device.discoverServices();
                          discover(device);
                        },
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    //discover(device);
                    return AlertDialog(
                      title: Text(device.name),
                      content: Text("Status: " +
                          snapshot.data.toString().split('.').last),
                      elevation: 24.0,
                      backgroundColor: Colors.lightGreenAccent,
                      actions: [
                        FlatButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RunningPage()),
                                ),
                            color: Colors.redAccent,
                            child: Text(
                              "Running",
                            ))
                      ],
                    );
                    break;
                  case BluetoothDeviceState.disconnected:
                    return Container(
                      color: Colors.redAccent,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.highlight_off),
                            title: Text("Status: " +
                                snapshot.data.toString().split('.').last),
                          ),
                        ],
                      ),
                    );
                    break;
                  default:
                    return Container(
                      color: Colors.yellowAccent,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.cached),
                            title: Text("Status: reconnecting"),
                          ),
                        ],
                      ),
                    );
                    break;
                }
              },
            ),

            /* StreamBuilder<List<int>>(
              stream: characteristic.value,
              initialData: characteristic.lastValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Text(snapshot.data.last.toString());
                } // else if (snapshot.data.toString() == '[]') discover(device);
                //loggerNoStack.i(snapshot.data.toString());
                else
                  Text("OK");
                // Text(value.toString() ?? '');
              },
            ),*/
          ],
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

Future<void> getval(BluetoothDevice _device) async {}

Future<void> discover(BluetoothDevice _device) async {
  service = await _device.discoverServices();

  service.forEach((service) {
    if (service.uuid.toString().toUpperCase().substring(4, 8) == "180D") {
      heartrate = service;
    }
  });

  heartrate.characteristics.forEach((hr) {
    if (hr.uuid.toString().toUpperCase().substring(4, 8) == "2A37") {
      characteristic = hr;
    }
  });

  await characteristic.setNotifyValue(!characteristic.isNotifying);
  await characteristic.read();
}
