import 'package:go_router/go_router.dart';
import 'package:kazan_guide/core/navigation/app_routes.dart';
import 'package:kazan_guide/features/main/main_screen.dart';
import 'package:kazan_guide/features/map/map_screen.dart';
import 'package:kazan_guide/features/point_details/point_details_screen.dart';
import 'package:kazan_guide/features/point_details/point_full_details_screen.dart';
import 'package:kazan_guide/features/route_details/route_details_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.mainPage,
      name: AppRoutes.mainPage,
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: AppRoutes.routeDetails,
          name: AppRoutes.routeDetails,
          builder:
              (context, state) =>
                  RouteDetailsScreen(routeId: state.uri.queryParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.map,
          name: AppRoutes.map,
          builder:
              (context, state) =>
                  MapScreen(routeId: state.uri.queryParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.pointDetails,
          name: AppRoutes.pointDetails,
          builder:
              (context, state) =>
                  PointDetailsScreen(pointId: state.uri.queryParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.pointFullDetails,
          name: AppRoutes.pointFullDetails,
          builder:
              (context, state) =>
                  PointFullDetailsScreen(pointId: state.uri.queryParameters['id']!),
        ),
      ],
    ),
  ],
);
