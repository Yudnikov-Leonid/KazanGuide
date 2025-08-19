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

abstract class RoutePointData {
  final LatLng latLng;

  double get lat => latLng.latitude;

  double get long => latLng.longitude;

  RoutePointData({required this.latLng});

  static RoutePointData fromJson(Map<String, dynamic> json) {
    if (json['points'] == null) {
      return RouteSinglePointData.fromJson(json);
    } else {
      return RouteMultiPointData.fromJson(json);
    }
  }
}

class RouteSinglePointData extends RoutePointData {
  final String pointName;
  final String shortDescription;
  final String fullDescription;

  RouteSinglePointData({
    required this.pointName,
    required super.latLng,
    required this.shortDescription,
    required this.fullDescription,
  });

  factory RouteSinglePointData.fromJson(Map<String, dynamic> json) =>
      RouteSinglePointData(
        pointName: json['name'],
        latLng: LatLng(json['lat'], json['long']),
        shortDescription: json['short_description'],
        fullDescription: json['full_description'],
      );

  factory RouteSinglePointData.fromJsonWithLatLng(
    Map<String, dynamic> json,
    LatLng latLng,
  ) => RouteSinglePointData(
    pointName: json['name'],
    latLng: latLng,
    shortDescription: json['short_description'],
    fullDescription: json['full_description'],
  );
}

class RouteMultiPointData extends RoutePointData {
  final List<RouteSinglePointData> points;

  RouteMultiPointData({required super.latLng, required this.points});

  factory RouteMultiPointData.fromJson(Map<String, dynamic> json) {
    final latLng = LatLng(json['lat'], json['long']);
    return RouteMultiPointData(
      latLng: latLng,
      points:
          (json['points'] as List<dynamic>)
              .map((e) => RouteSinglePointData.fromJsonWithLatLng(e, latLng))
              .toList(),
    );
  }
}
