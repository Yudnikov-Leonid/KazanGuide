import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/navigation/pages.dart';
import 'package:kazan_guide/core/presentation/KButton.dart';
import 'package:kazan_guide/core/presentation/photo_view.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({required this.route, super.key});

  final RouteData route;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: TripleAppBar(
      context,
      title: route.routeName,
      leadingFunction: () {
        AppNavigator.pop(context);
      },
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20, width: double.infinity),
            PhotosView(
              photos: route.routeImages.map((e) => 'assets/images/$e').toList(),
            ),
            const SizedBox(height: 16),
            Text(
              route.routeDescription,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 50),
            KButton(
              onPressed: () {
                AppNavigator.push(context, MapPage(route));
              },
              child: const SizedBox(
                width: 100,
                child: Center(
                  child: Text('Пройти', style: TextStyle(fontSize: 20)),
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
