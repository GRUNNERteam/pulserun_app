import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pulserun_app/models/localtion.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
const String DIRECTIONS_API = "AIzaSyBEuFGSRougNTQTRM1ZTnCD3abQ_NNAXOI";

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  var _geolocator = Geolocator();
  var _locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);
  LocationModel _locationModel = LocationModel();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  // config for Camera that define on upper code
  CameraPosition initialLocation = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
      target: SOURCE_LOCATION);

  //initState
  @override
  void initState() {
    super.initState();
    //setSourceAndDestinationIcons();
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: SOURCE_LOCATION,
        //icon: sourceIcon
      ));
      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: DEST_LOCATION,
        //icon: destinationIcon
      ));
    });
  }

  setPolylines() async {
    List<PointLatLng> result =
        (await polylinePoints?.getRouteBetweenCoordinates(
            DIRECTIONS_API,
            PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
            PointLatLng(DEST_LOCATION.latitude,
                DEST_LOCATION.longitude))) as List<PointLatLng>;

    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  Future<void> _goToTheLake() async {
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
    StreamSubscription<Position> positionStream = _geolocator
        .getPositionStream(_locationOptions)
        .listen((Position position) {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
      // add to list location model
      if (position != null) {
        _locationModel.addListLatLng(_locationModel.positionToLatLng(position));
      }
    });

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.688841, -74.044015), zoom: 11.00),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: onMapCreated,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Current Position!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
