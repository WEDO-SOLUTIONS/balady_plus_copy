import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// PageView for swiping through a list of images
class PhotoViewPager extends StatefulWidget {
  final PageController pageController;
  final bool doubleTapZoomable;
  final bool infinitelyScrollable;
  final ScrollPhysics scrollPhysics;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(bool)? showTitleBar;

  final List<String> imageSource;

  /// Create new instance, using the [easyImageProvider] to populate the [PageView],
  /// and the [pageController] to control the initial image index to display.
  /// The optional [doubleTapZoomable] boolean defaults to false and allows double tap to zoom.
  const PhotoViewPager({
    required this.pageController,
    required this.scrollPhysics,
    Key? key,
    this.doubleTapZoomable = false,
    this.showTitleBar,
    this.infinitelyScrollable = false,
    required this.imageSource,
  }) : super(key: key);

  @override
  State<PhotoViewPager> createState() => _PhotoViewPagerState();
}

class _PhotoViewPagerState extends State<PhotoViewPager> {
  @override
  Widget build(BuildContext context) => PhotoViewGallery.builder(
        scrollPhysics: widget.scrollPhysics,
        builder: _buildItem,
        itemCount: widget.imageSource.length,
        loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
        backgroundDecoration: const BoxDecoration(),
        pageController: widget.pageController,
        onPageChanged: (_) {},
        scaleStateChangedCallback: (value) {
          switch (value) {
            case PhotoViewScaleState.initial:
              widget.showTitleBar?.call(true);
            case PhotoViewScaleState.covering:
            case PhotoViewScaleState.originalSize:
            case PhotoViewScaleState.zoomedIn:
            case PhotoViewScaleState.zoomedOut:
              widget.showTitleBar?.call(false);
          }
        },
      );

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) => PhotoViewGalleryPageOptions(
        minScale: 0.1,
        imageProvider: CachedNetworkImageProvider(
          widget.imageSource[index],
        ),
      );
}
