import 'package:flutter/cupertino.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/features/main/main_screen.dart';
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
        key: ValueKey("route_details-${route.id}"),
      );
}

final class MapPage extends AppPage {
  MapPage(RouteData route)
    : super(
        name: "map_page",
        child: RouteDetailsScreen(route: route),
        key: ValueKey("map_page-${route.id}"),
      );
}
