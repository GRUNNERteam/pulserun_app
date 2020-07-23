import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  final Map<String, CameraPosition> _camaras = {};

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      print("set new target");
      _markers.clear();
      _camaras.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      final camara = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 11.00);
      _camaras["Current Location"] = camara;
      _markers["Current Location"] = marker;
    });
  }

  Future<void> _goToTheLake() async {
    print("goto campos");
    final GoogleMapController controller = await _controller.future;
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print("Pos : " +
        currentLocation.latitude.toString() +
        currentLocation.longitude.toString());
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 16)));
  }

  @override
  Widget build(BuildContext context) {
    print("MapPage");
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.688841, -74.044015), zoom: 11.00),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Current Position!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
