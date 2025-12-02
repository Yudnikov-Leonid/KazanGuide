import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan_guide/core/data/route_data.dart' as route_data;
import 'package:kazan_guide/core/di/dependencies.dart';
import 'package:kazan_guide/core/navigation/app_routes.dart';
import 'package:kazan_guide/core/presentation/KButton.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';
import 'package:kazan_guide/core/presentation/photo_view.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';

class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({required this.routeId, super.key});

  final String routeId;

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  late final route_data.RouteData _route;

  @override
  void initState() {
    _route = Dependencies.of(context).routesRepository.getRouteById(widget.routeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TripleAppBar(
      context,
      title: _route.routeName,
      leadingFunction: () {
        context.pop(context);
      },
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20, width: double.infinity),
            PhotosView(
              photos: _route.routeImages.map((e) => 'assets/images/$e').toList(),
            ),
            const SizedBox(height: 16),
            Text(
              _route.routeDescription,
              textAlign: TextAlign.justify,
              style: context.textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 50),
            KButton(
              onPressed: () {
                HapticFeedback.heavyImpact();

                context.pushNamed(AppRoutes.map, queryParameters: {'id': _route.id});
              },
              child: const SizedBox(
                width: 100,
                child: Center(
                  child: FittedBox(
                    child: Text('Пройти', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}
