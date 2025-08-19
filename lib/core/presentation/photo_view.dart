import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PhotosView extends StatelessWidget {
  const PhotosView({required this.photos, super.key});

  final List<String> photos;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children:
          photos
              .mapIndexed(
                (i, asset) => _Photo(
                  key: Key('$asset-$i'),
                  asset: asset,
                  index: i,
                  photos: photos,
                ),
              )
              .toList(),
    ),
  );
}

class _Photo extends StatelessWidget {
  const _Photo({
    required this.asset,
    required this.index,
    required this.photos,
    super.key,
  });

  final String asset;
  final int index;
  final List<String> photos;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => PhotosPreviewDialog(assets: photos, index: index),
      );
    },
    child: Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(asset, height: 140, width: 140, fit: BoxFit.cover),
      ),
    ),
  );
}

class PhotosPreviewDialog extends StatelessWidget {
  const PhotosPreviewDialog({
    required this.assets,
    required this.index,
    super.key,
  });

  final List<String> assets;
  final int index;

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, size: 30, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 400,
          child: PageView(
            controller: PageController(
              viewportFraction: 0.8,
              initialPage: index,
            ),
            children: assets.map(_photo).toList(),
          ),
        ),
        const SizedBox(height: 60),
      ],
    ),
  );

  Widget _photo(String asset) => Container(
    height: 400,
    width: 400,
    margin: const EdgeInsets.symmetric(horizontal: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(asset, fit: BoxFit.cover, height: 400, width: 400),
    ),
  );
}
