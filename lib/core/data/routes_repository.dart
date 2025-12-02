import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kazan_guide/core/data/route_data.dart';

class RoutesRepository {
  List<RouteData> _cache = [];

  Future<List<RouteData>> loadRoutes() async {
    if (_cache.isEmpty) {
      final data = jsonDecode(
        await rootBundle.loadString("assets/data/routes.json"),
      );
      _cache = data.map<RouteData>((e) => RouteData.fromJson(e)).toList();
    }

    return _cache;
  }

  RouteData getRouteById(String id) => _cache.where((e) => e.id == id).first;

  RouteSinglePointData getSinglePointById(String id) {
    for (final route in _cache) {
      for (final point in route.points) {
        if (point is RouteSinglePointData) {
          if (point.id == id) return point;
        } else if (point is RouteMultiPointData) {
          final finds = point.points.where((p) => p.id == id);
          if (finds.isNotEmpty) return finds.first;
        }
      }
    }

    throw Exception('Point with id $id not found');
  }
}
