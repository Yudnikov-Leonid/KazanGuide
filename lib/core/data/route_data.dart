import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class RouteData extends GoRouteData {
  final String id;
  final String routeName;
  final String routeDescription;
  final String routeImage;
  final List<String> routeImages;
  final List<RoutePointData> points;

  RouteData({
    required this.id,
    required this.routeName,
    required this.routeDescription,
    required this.routeImage,
    required this.routeImages,
    required this.points,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) => RouteData(
    id: json['id'],
    routeName: json['route_name'],
    routeDescription: json['route_description'],
    routeImage: json['route_image'],
    routeImages:
        (json['route_images'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
    points:
        (json['points'] as List<dynamic>)
            .map((e) => RoutePointData.fromJson(e))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'routeName': routeName,
    'routeDescription': routeDescription,
    'routeImage': routeImage,
    'routeImages': routeImages,
    'points': points.map((p) => p.toJson()),
  };
}

abstract class RoutePointData extends GoRouteData {
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

  Map<String, dynamic> toJson();
}

class RouteSinglePointData extends RoutePointData {
  final String id;
  final String pointName;
  final String shortDescription;
  final String fullDescription;
  final String? audioRu;
  final String? audioTat;
  final List<String> images;

  RouteSinglePointData({
    required this.id,
    required this.pointName,
    required super.latLng,
    required this.shortDescription,
    required this.fullDescription,
    required this.audioRu,
    required this.audioTat,
    required this.images,
  });

  factory RouteSinglePointData.fromJson(Map<String, dynamic> json) =>
      RouteSinglePointData.fromJsonWithLatLng(
        json,
        LatLng(json['lat'], json['long']),
      );

  factory RouteSinglePointData.fromJsonWithLatLng(
    Map<String, dynamic> json,
    LatLng latLng,
  ) => RouteSinglePointData(
    id: json['id'],
    pointName: json['name'],
    latLng: latLng,
    shortDescription: json['short_description'],
    fullDescription: json['full_description'],
    audioRu: json['audio_ru'],
    audioTat: json['audio_tat'],
    images: (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': pointName,
    'lat': lat,
    'long': long,
    'short_description': shortDescription,
    'fullDescription': fullDescription,
    'audio_ru': audioRu,
    'audio_tat': audioTat,
    'images': images,
  };
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

  @override
  Map<String, dynamic> toJson() {
    if (points.isEmpty) return {};

    return {
      'lat': points.first.lat,
      'long': points.first.long,
      'points': points.map((p) => p.toJson()),
    };
  }
}
