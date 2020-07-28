import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pulserun_app/models/localtion.dart';

const String DIRECTIONS_API = "AIzaSyBEuFGSRougNTQTRM1ZTnCD3abQ_NNAXOI";

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  // Position Model
  LocationModel _pos = new LocationModel();
  Geolocator _geolocator = new Geolocator();
  GoogleMapController mapController;

  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();

  var _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10,
  );

  double _zoomLevel = 14;

  bool isEnd = false;
  bool isTracking = false;
  @override
  void initState() {
    print("init State");
    super.initState();

    if (isTracking) {
    } else {
      _startTracking();
    }

    if (isEnd) {
      /// destination marker
      _addMarker(
        _pos.destination,
        "destination",
        descriptor: BitmapDescriptor.defaultMarkerWithHue(90),
      );
    }
    //_getPolyline();
  }

  Future<void> _startTracking() async {
    Position _result = await _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    isTracking = true;
    _pos.addOrignLatLng(_pos.positionToLatLng(_result));
    goToOrigin(); // For displaying user
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id,
      {BitmapDescriptor descriptor = BitmapDescriptor.defaultMarker}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    _markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: _polylineCoordinates,
    );
    _polylines[id] = polyline;
    setState(() {});
  }

  // ignore: unused_element
  _getPolyline() async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      DIRECTIONS_API,
      _pos.getOriginPointLatLng(),
      _pos.getLastPointLatLng(),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(
          point.latitude,
          point.longitude,
        ));
      });
    }
    _addPolyLine();
  }

  // google map cam
  void goToOrigin() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _pos.origin,
      zoom: _zoomLevel,
    )));
  }

  void goToCurrent() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _pos.lastPos,
      zoom: _zoomLevel,
    )));
  }

  @override
  Widget build(BuildContext context) {
    // stream location
    // ignore: unused_local_variable
    StreamSubscription<Position> positionStream = _geolocator
        .getPositionStream(_locationOptions)
        .listen((Position position) {
      if (position != null) {
        if (isTracking) {
          _pos.addListLatLng(_pos.positionToLatLng(position));
          _polylineCoordinates.add(_pos.lastPos);
          _addPolyLine();
          print("SetState Action!~~");
          setState(() {});
        }
      }
    });

    /// Last for dest marker
    _addMarker(
      _pos.origin,
      "origin",
      descriptor: BitmapDescriptor.defaultMarkerWithHue(90),
    );
    print("Creating Map Page!!!");

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _pos.lastPos, zoom: 15),
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(_markers.values),
        polylines: Set<Polyline>.of(_polylines.values),
      ),
    );
  }
}
