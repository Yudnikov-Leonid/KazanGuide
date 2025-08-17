import 'package:latlong2/latlong.dart';

class RouteData {
  final String routeName;
  final String routeDescription;
  final List<RoutePointData> points;

  RouteData({
    required this.routeName,
    required this.routeDescription,
    required this.points,
  });
}

class RoutePointData {
  final String pointName;
  final LatLng latLng;
  final String shortDescription;
  final String fullDescription;

  RoutePointData({
    required this.pointName,
    required this.latLng,
    required this.shortDescription,
    required this.fullDescription,
  });
}
