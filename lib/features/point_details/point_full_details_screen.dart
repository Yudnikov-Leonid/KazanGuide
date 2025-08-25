import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';

class PointFullDetailsScreen extends StatelessWidget {
  const PointFullDetailsScreen({required this.point, super.key});

  final RouteSinglePointData point;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: TripleAppBar(
      context,
      title: point.pointName,
      leadingFunction: () {
        AppNavigator.pop(context);
      },
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              point.fullDescription,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),
            if (point.fullDescription.isNotEmpty)
              TextButton(
                onPressed: () {
                  AppNavigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey.shade600,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.navigate_before), Text('Назад')],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
