import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';

class PointDetailsScreen extends StatelessWidget {
  const PointDetailsScreen({required this.point, super.key});

  final RoutePointData point;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TripleAppBar(
      context,
      title: point.pointName,
      leadingFunction: () {
        AppNavigator.pop(context);
      },
    ),
  );
}
