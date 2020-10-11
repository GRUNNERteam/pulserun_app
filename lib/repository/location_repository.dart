import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pulserun_app/models/localtion.dart';
import 'package:pulserun_app/services/trackloc/trackloc.dart';

abstract class LocationRepository {
  Future<LocationModel> uploadToDB();
  Future<double> getDistance();
  TrackingLocationService getService();
  Future<bool> setService();
  Future<bool> setPos(PositionModel pos);
  Future<bool> setRef(DocumentReference docRef);
}

class LocationServiceAndTracking implements LocationRepository {
  final TrackingLocationService _trackingLocationService =
      TrackingLocationService();
  DocumentReference _reference;

  @override
  Future<LocationModel> uploadToDB() async {
    await this._reference.set(_trackingLocationService.getData().toMap());
    return this._trackingLocationService.getData();
  }

  @override
  Future<bool> setService() async {
    try {
      this._trackingLocationService.cleanData();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setPos(PositionModel pos) async {
    try {
      this._trackingLocationService.addToList(pos);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setRef(DocumentReference docRef) async {
    try {
      this._reference = docRef;
      return true;
    } catch (e) {
      debugPrint(e);
      return false;
    }
  }

  @override
  Future<double> getDistance() async {
    // ignore: await_only_futures
    return await _trackingLocationService.distanceCentToKM();
  }

  @override
  TrackingLocationService getService() {
    return this._trackingLocationService;
  }
}
