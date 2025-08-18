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

  factory RouteData.fromJson(Map<String, dynamic> json) => RouteData(
    routeName: json['route_name'],
    routeDescription: json['route_description'],
    points:
        (json['points'] as List<dynamic>)
            .map((e) => RoutePointData.fromJson(e))
            .toList(),
  );
}

class RoutePointData {
  final String pointName;
  final LatLng latLng;
  final String shortDescription;
  final String fullDescription;

  double get lat => latLng.latitude;

  double get long => latLng.longitude;

  RoutePointData({
    required this.pointName,
    required this.latLng,
    required this.shortDescription,
    required this.fullDescription,
  });

  factory RoutePointData.fromJson(Map<String, dynamic> json) => RoutePointData(
    pointName: json['name'],
    latLng: LatLng(json['lat'], json['long']),
    shortDescription: json['short_description'],
    fullDescription: json['full_description'],
  );
}
