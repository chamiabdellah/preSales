
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoUtil{

  static Future<bool> handleLocationPermission(BuildContext context) async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      final bool isAllowed = await Geolocator.openAppSettings();
      if(isAllowed && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }

  static Future<Position?> getUserLocation(BuildContext context) async {
    bool isPermitted = await GeoUtil.handleLocationPermission(context);

    if(isPermitted) {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, timeLimit: const Duration(seconds: 30));
    } else {
      return null;
    }
  }


}