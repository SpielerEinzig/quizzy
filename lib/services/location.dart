import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

class LocationService {
  late Address currentAddress;

  late double longitude;
  late double latitude;

  Future<String?> getCurrentLocation({required context}) async {
    bool locationServiceEnabled;
    LocationPermission permission;

    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!locationServiceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enable location service"),
        ),
      );
    } else if (locationServiceEnabled) {
      permission = await Geolocator.requestPermission();

      // if location permission is denied
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enable location service"),
          ),
        );

        permission;
      }
      //if location permission is denied forever
      else if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location service denied forever"),
          ),
        );

        permission;
      }

      //get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      longitude = position.longitude;
      latitude = position.latitude;

      //get address with longitude and latitude
      currentAddress = await GeoCode()
          .reverseGeocoding(latitude: latitude, longitude: longitude);
    }

    return currentAddress.city;
  }
}
