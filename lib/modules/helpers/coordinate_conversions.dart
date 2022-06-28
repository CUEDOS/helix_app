import 'package:latlng/latlng.dart';
import 'dart:math';

class Geodetic {
  LatLng latLng;
  double altitude;
  Geodetic(this.latLng, this.altitude);
}

class NED {
  double north;
  double east;
  double down;
  NED(this.north, this.east, this.down);
}

class Cartesian {
  double x;
  double y;
  double z;
  Cartesian(this.x, this.y, this.z);
}

class Ellipsoid {
  final double semiMajorAxis;
  final double semiMinorAxis;
  late double flattening;
  late double thirdFlattening;
  late double eccentricity;
  Ellipsoid({
    required this.semiMajorAxis,
    required this.semiMinorAxis,
  }) {
    _initFlattening();
    _initThirdFlattening();
    _initEccentricity();
  }

  _initFlattening() {
    flattening = (semiMajorAxis - semiMinorAxis) / semiMajorAxis;
  }

  _initThirdFlattening() {
    thirdFlattening =
        (semiMajorAxis - semiMinorAxis) / (semiMajorAxis + semiMinorAxis);
  }

  _initEccentricity() {
    eccentricity = sqrt(2 * flattening - pow(flattening, 2));
  }
}

Ellipsoid wgs84 =
    Ellipsoid(semiMajorAxis: 6378137.0, semiMinorAxis: 6356752.31424518);

Geodetic ned2Geodetic(NED nedCoordinates, Geodetic refGeodetic) {
  Cartesian ecef = ned2Ecef(nedCoordinates, refGeodetic);

  return ecef2Geodetic(ecef);
}

Cartesian ned2Ecef(NED nedCoordinates, Geodetic refGeodetic) {
  Cartesian ecef0 = geodetic2Ecef(refGeodetic);
  Cartesian displacement = ned2Cartesian(nedCoordinates, refGeodetic.latLng);
  return Cartesian(ecef0.x + displacement.x, ecef0.y + displacement.y,
      ecef0.z + displacement.z);
}

Cartesian geodetic2Ecef(Geodetic geodetic) {
  double longitude =
      geodetic.latLng.longitude * pi / 180; //add santise function
  double latitude = geodetic.latLng.latitude * pi / 180; //convert to radians

  //radius of curvature of prime vertical section
  var N = pow(wgs84.semiMajorAxis, 2) /
      sqrt(pow(wgs84.semiMajorAxis, 2) * pow(cos(latitude), 2) +
          pow(wgs84.semiMinorAxis, 2) * pow(sin(latitude), 2));

  // compute cartesian geocentric from curvilinear geodetic coordinates
  var x = (N + geodetic.altitude) * cos(latitude) * cos(longitude);
  var y = (N + geodetic.altitude) * cos(latitude) * sin(longitude);
  var z = (N * pow((wgs84.semiMinorAxis / wgs84.semiMajorAxis), 2) +
          geodetic.altitude) *
      sin(latitude);
  return Cartesian(x, y, z);
}

Geodetic ecef2Geodetic(Cartesian ecef) {
  //based on:
  //You, Rey-Jer. (2000). Transformation of Cartesian to Geodetic Coordinates without Iterations.
  //Journal of Surveying Engineering. doi: 10.1061/(ASCE)0733-9453

  var r = sqrt(pow(ecef.x, 2) + pow(ecef.y, 2) + pow(ecef.z, 2));

  var E = sqrt(pow(wgs84.semiMajorAxis, 2) - pow(wgs84.semiMinorAxis, 2));

  var u = sqrt(0.5 * (pow(r, 2) - pow(E, 2)) +
      0.5 *
          sqrt(pow((pow(r, 2) - pow(E, 2)), 2) +
              4 * pow(E, 2) * pow(ecef.z, 2)));

  var Q = sqrt(pow(ecef.x, 2) + pow(ecef.y, 2));

  var huE = sqrt(pow(u, 2) + pow(E, 2));

  var beta = atan(huE / u * ecef.z / Q);

  var eps = ((wgs84.semiMinorAxis * u - wgs84.semiMajorAxis * huE + pow(E, 2)) *
          sin(beta)) /
      (wgs84.semiMajorAxis * huE * 1 / cos(beta) - pow(E, 2) * cos(beta));

  beta += eps;

  var latitude = atan(wgs84.semiMajorAxis / wgs84.semiMinorAxis * tan(beta));

  var longitude = atan2(ecef.y, ecef.x);

  var altitude = sqrt(pow((ecef.z - wgs84.semiMinorAxis * sin(beta)), 2) +
      pow((Q - wgs84.semiMajorAxis * cos(beta)), 2));

  bool inside = (pow(ecef.x, 2) / pow(wgs84.semiMajorAxis, 2) +
          pow(ecef.y, 2) / pow(wgs84.semiMajorAxis, 2) +
          pow(ecef.z, 2) / pow(wgs84.semiMinorAxis, 2) <
      1);

  if (inside) {
    altitude = -altitude;
  }

  latitude = latitude * 180 / pi;
  longitude = longitude * 180 / pi;

  return Geodetic(LatLng(latitude, longitude), altitude);
}

Cartesian ned2Cartesian(NED ned, LatLng refLatLng) {
  //convert to radians
  double refLongitude = refLatLng.longitude * pi / 180;
  double refLatitude = refLatLng.latitude * pi / 180;

  var t = cos(refLatitude) * -ned.down - sin(refLatitude) * ned.north;
  var z = sin(refLatitude) * -ned.down + cos(refLatitude) * ned.north;

  var x = cos(refLongitude) * t - sin(refLongitude) * ned.east;
  var y = sin(refLongitude) * t + cos(refLongitude) * ned.east;

  return Cartesian(x, y, z);
}
