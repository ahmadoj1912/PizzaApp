import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  double _lat = 0.0;
  double _lon = 0.0;

  double get lat => _lat;
  double get lon => _lon;

  Future<void> changeLocation(LatLng position) async {
    try {
      final fbs = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      await fbs.collection('location').doc(auth.currentUser!.uid).set(
          {'latitude': position.latitude, 'longitude': position.longitude});
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfUserLocationExist() async {
    try {
      final fbs = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final result =
          await fbs.collection('location').doc(auth.currentUser!.uid).get();
      if (result.exists) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchLocation() async {
    try {
      final fbs = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final result =
          await fbs.collection('location').doc(auth.currentUser!.uid).get();

      double latitude = result.data()!['latitude'];
      double longitude = result.data()!['longitude'];

      _lat = latitude;
      _lon = longitude;

      update();
    } catch (error) {
      throw error;
    }
  }
}
