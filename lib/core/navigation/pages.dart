import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/features/main/main_screen.dart';

sealed class AppPage extends MaterialPage<void> {
  const AppPage({
    required String super.name,
    required Map<String, Object?>? super.arguments,
    required super.child,
    required LocalKey super.key,
  });

  @override
  String get name => super.name ?? "Unknown Page";
}

final class MainPage extends AppPage {
  MainPage()
    : super(
        name: "main",
        arguments: null,
        child: const MainScreen(),
        key: ValueKey("main"),
      );
}

final class RouteDetailsPage extends AppPage {
  RouteDetailsPage(RouteData route)
    : super(
        name: "route_details",
        arguments: {"route": route},
        child: const MainScreen(),
        key: ValueKey("route_details"),
      );
}
