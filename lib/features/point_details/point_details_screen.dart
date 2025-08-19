import 'package:flutter/material.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/presentation/photo_view.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/point_details/audio_widget.dart';

class PointDetailsScreen extends StatefulWidget {
  const PointDetailsScreen({required this.point, super.key});

  final RouteSinglePointData point;

  @override
  State<PointDetailsScreen> createState() => _PointDetailsScreenState();
}

class _PointDetailsScreenState extends State<PointDetailsScreen> {
  bool _isFullDescription = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: TripleAppBar(
      context,
      title: widget.point.pointName,
      leadingFunction: () {
        AppNavigator.pop(context);
      },
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const PhotosView(
              photos: [
                'assets/images/test_photo.jpg',
                'assets/images/test_photo.jpg',
                'assets/images/test_photo.jpg',
                'assets/images/test_photo.jpg',
                'assets/images/test_photo.jpg',
              ],
            ),
            const SizedBox(height: 16),
            AudioWidget(assetSource: 'audio/test_audio.mp3', name: 'RUS'),
            const SizedBox(height: 16),
            AudioWidget(assetSource: 'audio/test_audio_2.mp3', name: 'TAT'),
            const SizedBox(height: 16),
            Text(
              _isFullDescription
                  ? widget.point.fullDescription
                  : widget.point.shortDescription,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),
            if (widget.point.fullDescription.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isFullDescription = !_isFullDescription;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey.shade600,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isFullDescription
                          ? 'Показать короткое описание'
                          : 'Показать полное описание',
                    ),
                    const Icon(Icons.navigate_next),
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
