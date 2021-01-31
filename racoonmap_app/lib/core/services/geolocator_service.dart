import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  double getDistance(Unit unit, double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distance = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    return (unit == Unit.m) ? distance : distance / 1609;
  }

  String getFormattedDistance(Unit unit, double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) {
    double distance = getDistance(
        unit, startLatitude, startLongitude, endLatitude, endLongitude);

    String unitString;
    if (unit == Unit.m && distance > 1000) {
      distance /= 1000;
      unitString = "km";
      return distance.toStringAsPrecision(2) + " " + unitString;
    } else {
      unitString = describeEnum(unit);
      return distance.round().toString() + " " + unitString;
    }
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

enum Unit { m, mi }
