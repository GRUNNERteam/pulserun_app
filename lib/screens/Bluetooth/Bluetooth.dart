import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulserun_app/src/ble/ble_device_connector.dart';
import 'package:pulserun_app/src/ble/ble_scanner.dart';
import 'package:pulserun_app/src/ble/ble_status_monitor.dart';
import 'package:pulserun_app/src/ui/ble_status_screen.dart';
import 'package:pulserun_app/src/ui/device_list.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

final _ble = FlutterReactiveBle();
final _scanner = BleScanner(_ble);
final _monitor = BleStatusMonitor(_ble);
final _connector = BleDeviceConnector(_ble);

class BLE extends StatefulWidget {
  @override
  _BLEState createState() => _BLEState();
}

class _BLEState extends State<BLE> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        StreamProvider<BleScannerState>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Reactive BLE example',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return DeviceListScreen();
          } else {
            return BleStatusScreen(status: status);
          }
        },
      );
}
