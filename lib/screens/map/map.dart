import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const String DIRECTIONS_API = "AIzaSyBEuFGSRougNTQTRM1ZTnCD3abQ_NNAXOI";

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  LocationOptions _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10,
    timeInterval: 100,
  );

  // Position Model
  LocationModel _pos = new LocationModel();
  Geolocator _geolocator = new Geolocator();
  GoogleMapController mapController;

  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();

  double _zoomLevel = 20;
  LatLng initPos;
  bool isInit = false;
  bool isEnd = false;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();

    //_getPolyline();
  }

  void initGoogleMap() async {
    Position _result = await _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    this.initPos = _pos.positionToLatLng(_result);
    this.isInit = true;
    print("initGoogleMap Completed!");

    setState(() {});
  }

  // tracking part
  Future<void> _startTracking() async {
    print("Start Tracking location");
    Position _result = await _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    setState(() {
      /// Last for origin marker
      _addMarker(
        _pos.origin,
        "origin",
        descriptor: BitmapDescriptor.defaultMarkerWithHue(90),
      );
      this.isTracking = true;
      _pos.addOrignLatLng(_pos.positionToLatLng(_result));
      goToOrigin();
    });
// For displaying user
  }

  Future<void> _stopTracking() async {
    print("Stop Tracking location");
    Position _result = await _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    setState(() {
      this.isTracking = false;
      _pos.addDestination(_pos.positionToLatLng(_result));
      goToCurrent();
    });
  }

  // set controller
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

  // floatingActionButton
  FloatingActionButton btnTracking(context) {
    if (!isTracking) {
      return FloatingActionButton.extended(
          onPressed: () async {
            await _startTracking();
          },
          label: Text("Start Tracking"));
    } else {
      return FloatingActionButton.extended(
          onPressed: () async {
            await _stopTracking();
            _pos.clear();
          },
          label: Text("Stop Tracking"));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInit) {
      initGoogleMap();
    }

    if (isTracking) {
      print("isTracking in build");
      _geolocator
          .getPositionStream(_locationOptions)
          .listen((Position _posStream) {
        if (_posStream != null) {
          _pos.addListLatLng(_pos.positionToLatLng(_posStream));
          _polylineCoordinates.add(_pos.lastPos);
          goToCurrent();
          _addPolyLine();
        }
      });
    }

    print("Creating Map Page!!!");

    return Scaffold(
      body: !isInit
          ? Center(
              child: SpinKitCubeGrid(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initPos,
                zoom: 18,
              ),
              compassEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(_markers.values),
              polylines: Set<Polyline>.of(_polylines.values),
            ),
      floatingActionButton: btnTracking(context),
    );
  }
}
