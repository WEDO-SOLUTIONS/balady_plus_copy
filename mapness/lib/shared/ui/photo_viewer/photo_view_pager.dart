import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// PageView for swiping through a list of images
class PhotoViewPager extends StatefulWidget {
  final PageController pageController;
  final bool doubleTapZoomable;
  final bool infinitelyScrollable;
  final ScrollPhysics scrollPhysics;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function({required bool visible})? showTitleBar;

  final List<String> imageSource;
  final List<String> imagePreviews;

  /// Create new instance, using the [easyImageProvider] to populate the [PageView],
  /// and the [pageController] to control the initial image index to display.
  /// The optional [doubleTapZoomable] boolean defaults to false and allows double tap to zoom.
  const PhotoViewPager({
    required this.pageController,
    required this.scrollPhysics,
    required this.imageSource,
    required this.imagePreviews,
    Key? key,
    this.doubleTapZoomable = false,
    this.showTitleBar,
    this.infinitelyScrollable = false,
  }) : super(key: key);

  @override
  State<PhotoViewPager> createState() => _PhotoViewPagerState();
}

class _PhotoViewPagerState extends State<PhotoViewPager> {
  int? imageIndex;

  String? _previewForIndex(int index) {
    if (index < 0 || index >= widget.imagePreviews.length) {
      return null;
    }
    return widget.imagePreviews[index];
  }

  Widget _buildPageImage(int index) {
    final previewUrl = _previewForIndex(index);
    final imageUrl = widget.imageSource[index];

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, __) => previewUrl != null
          ? Image(image: CachedNetworkImageProvider(previewUrl))
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageIndex != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            imageIndex = null;
            widget.showTitleBar?.call(visible: true);
          });
        },
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.imageSource[imageIndex!]),
          minScale: .1,
          scaleStateChangedCallback: (value) {
            switch (value) {
              case PhotoViewScaleState.initial:
                widget.showTitleBar?.call(visible: false);
                setState(() => imageIndex = null);
              case PhotoViewScaleState.originalSize:
                widget.showTitleBar?.call(visible: true);
                setState(() => imageIndex = null);
              case PhotoViewScaleState.covering:
              case PhotoViewScaleState.zoomedIn:
              case PhotoViewScaleState.zoomedOut:
                widget.showTitleBar?.call(visible: false);
            }
          },
        ),
      );
    }
    return PageView.builder(
      key: const PageStorageKey('photo_pager'),
      itemCount: widget.infinitelyScrollable ? null : widget.imageSource.length,
      controller: widget.pageController,
      itemBuilder: (context, index) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            imageIndex = index;
            widget.showTitleBar?.call(visible: false);
          });
        },
        child: _buildPageImage(index),
      ),
    );
  }
}
