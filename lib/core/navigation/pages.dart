import 'package:flutter/cupertino.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/features/main/main_screen.dart';
import 'package:kazan_guide/features/map/map_screen.dart';
import 'package:kazan_guide/features/point_details/point_details_screen.dart';
import 'package:kazan_guide/features/point_details/point_full_details_screen.dart';
import 'package:kazan_guide/features/route_details/route_details_screen.dart';

sealed class AppPage extends CupertinoPage<void> {
  const AppPage({
    required String super.name,
    required super.child,
    required LocalKey super.key,
  });

  @override
  String get name => super.name ?? "Unknown Page";

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppPage && key == other.key;
}

final class MainPage extends AppPage {
  const MainPage()
    : super(
        name: "main",
        child: const MainScreen(),
        key: const ValueKey("main"),
      );
}

final class RouteDetailsPage extends AppPage {
  RouteDetailsPage(RouteData route)
    : super(
        name: "route_details",
        child: RouteDetailsScreen(route: route),
        key: ValueKey("route_details-${route.routeName}"),
      );
}

final class MapPage extends AppPage {
  MapPage(RouteData route)
    : super(
        name: "map_page",
        child: MapScreen(route: route),
        key: ValueKey("map_page-${route.routeName}"),
      );
}

final class PointDetailsPage extends AppPage {
  PointDetailsPage(RouteSinglePointData point)
    : super(
        name: "point_details_page",
        child: PointDetailsScreen(point: point),
        key: ValueKey("point_details_page-${point.pointName}"),
      );
}

final class PointFullDetailsPage extends AppPage {
  PointFullDetailsPage(RouteSinglePointData point)
    : super(
        name: "point_full_details_page",
        child: PointFullDetailsScreen(point: point),
        key: ValueKey("point_full_details_page-${point.pointName}"),
      );
}
