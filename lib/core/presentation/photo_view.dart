import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';

class PhotosView extends StatelessWidget {
  const PhotosView({required this.photos, required this.padding, super.key});

  final List<String> photos;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: padding,
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
    onTap: () async {
      await showDialog(
        context: context,
        builder: (context) => PhotosPreviewDialog(assets: photos, index: index),
      );
    },
    child: Container(
      height: 210,
      width: 210,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(asset, height: 140, width: 140, fit: BoxFit.cover),
      ),
    ),
  );
}

class PhotosPreviewDialog extends StatefulWidget {
  const PhotosPreviewDialog({required this.assets, required this.index, super.key});

  final List<String> assets;
  final int index;

  @override
  State<PhotosPreviewDialog> createState() => _PhotosPreviewDialogState();
}

class _PhotosPreviewDialogState extends State<PhotosPreviewDialog> {
  final _focusNode = FocusNode();
  late final _pageController = PageController(
    viewportFraction: 1,
    initialPage: widget.index,
  );

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeys(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_pageController.page == null ||
          _pageController.page == widget.assets.length - 1)
        return;

      /// jumpTo not working for some reason
      _pageController.animateToPage(
        _pageController.page!.round() + 1,
        duration: const Duration(milliseconds: 1),
        curve: Curves.ease,
      );
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_pageController.page == null || _pageController.page == 0) return;

      _pageController.animateToPage(
        _pageController.page!.round() - 1,
        duration: const Duration(milliseconds: 1),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
    autofocus: true,
    focusNode: _focusNode,
    onKeyEvent: _handleKeys,
    child: Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
            ),
          ),
          SizedBox(
            height: context.screenSize.height,
            width: context.screenSize.width,
            child: PageView(
              controller: _pageController,
              children:
                  widget.assets.map((asset) => _photo(context, asset)).toList(),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _photo(BuildContext context, String asset) => GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        //border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [GestureDetector(onTap: () {}, child: Image.asset(asset))],
      ),
    ),
  );
}
