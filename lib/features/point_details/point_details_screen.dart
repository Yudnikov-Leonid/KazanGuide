import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/navigation/pages.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';
import 'package:kazan_guide/core/presentation/photo_view.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/point_details/audio_widget.dart';

class PointDetailsScreen extends StatelessWidget {
  const PointDetailsScreen({required this.point, super.key});

  final RouteSinglePointData point;

  @override
  Widget build(BuildContext context) => Scaffold(
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
            const SizedBox(height: 20, width: double.infinity),
            PhotosView(
              photos: point.images.map((e) => 'assets/images/$e').toList(),
            ),
            const SizedBox(height: 16),
            if (point.audioRu != null) ...[
              AudioWidget(assetSource: 'audio/${point.audioRu}', name: 'RUS'),
              const SizedBox(height: 16),
            ],
            if (point.audioTat != null) ...[
              AudioWidget(assetSource: 'audio/${point.audioTat}', name: 'TAT'),
              const SizedBox(height: 16),
            ],
            Text(
              point.shortDescription,
              textAlign: TextAlign.justify,
              style: context.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            if (point.fullDescription.isNotEmpty)
              TextButton(
                onPressed: () {
                  AppNavigator.push(context, PointFullDetailsPage(point));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey.shade600,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Показать полное описание'),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
