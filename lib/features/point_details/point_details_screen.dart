import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/di/dependencies.dart';
import 'package:kazan_guide/core/navigation/app_routes.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';
import 'package:kazan_guide/core/presentation/photo_view.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/point_details/audio_widget.dart';

class PointDetailsScreen extends StatefulWidget {
  const PointDetailsScreen({required this.pointId, super.key});

  final String pointId;

  @override
  State<PointDetailsScreen> createState() => _PointDetailsScreenState();
}

class _PointDetailsScreenState extends State<PointDetailsScreen> {
  late final RouteSinglePointData _point;

  @override
  void initState() {
    _point = Dependencies.of(
      context,
    ).routesRepository.getSinglePointById(widget.pointId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TripleAppBar(
      context,
      title: _point.pointName,
      leadingFunction: () {
        context.pop();
      },
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20, width: double.infinity),
            PhotosView(
              photos: _point.images.map((e) => 'assets/images/$e').toList(),
            ),
            const SizedBox(height: 16),
            if (_point.audioRu != null) ...[
              AudioWidget(assetSource: 'audio/${_point.audioRu}', name: 'RUS'),
              const SizedBox(height: 16),
            ],
            if (_point.audioTat != null) ...[
              AudioWidget(assetSource: 'audio/${_point.audioTat}', name: 'TAT'),
              const SizedBox(height: 16),
            ],
            SelectableText(
              _point.shortDescription,
              textAlign: TextAlign.justify,
              style: context.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            if (_point.fullDescription.isNotEmpty)
              TextButton(
                onPressed: () {
                  context.pushNamed(
                    AppRoutes.pointFullDetails,
                    queryParameters: {'id': _point.id},
                  );
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
