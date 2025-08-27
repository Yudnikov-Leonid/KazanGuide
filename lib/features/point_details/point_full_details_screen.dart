import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';

class PointFullDetailsScreen extends StatelessWidget {
  const PointFullDetailsScreen({required this.point, super.key});

  final RouteSinglePointData point;

  @override
  Widget build(BuildContext context) {
    final split = point.fullDescription.split('||');

    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ...split.map((e) {
                if (e.startsWith('image:')) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Image.asset('assets/images/${e.substring(6)}'),
                    ),
                  );
                }

                return Text(
                  e,
                  textAlign: TextAlign.justify,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }).toList(),
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
}
