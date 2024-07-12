import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({
    required this.photoPaths,
    required this.currentPhotoIndex,
    super.key,
  });
  final List<String>? photoPaths;
  final int currentPhotoIndex;

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  static const backgroundColor = Color(0xff0B1218);

  late PageController _pageController;
  late ValueNotifier<bool> _isAppBarVisible;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentPhotoIndex);
    _isAppBarVisible = ValueNotifier(true);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _isAppBarVisible,
        builder: (context, isAppBarVisible, child) => Material(
          color: backgroundColor,
          child: Material(
            color: isAppBarVisible ? context.color.surfaceContrastHigh : Colors.transparent,
            child: Scaffold(
              appBar: isAppBarVisible
                  // TODO: Update when BaladyTopBar starts supporting background color
                  ? BaladyTopBar(
                      textStyle: context.textStyle.callout.copyWith(color: Colors.white),
                      title: context.l10n.photos,

                      /// TODO(ui_kit): Fix leading in UIKIT
                      leading: Container(
                        padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
                        alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
                        child: Icon(
                          context.isLTR ? SystemIcons.arrowCornerLeftLarge : SystemIcons.arrowCornerRightLarge,
                          color: Colors.white,
                        ),
                      ),
                      onLeadingPressed: () => context.pop(),
                    )
                  : null,
              body: child,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => _isAppBarVisible.value = !_isAppBarVisible.value,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: DecoratedBox(
              decoration: const BoxDecoration(color: backgroundColor),
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (ctx, index) {
                      final photo = widget.photoPaths![index];
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(photo),
                        initialScale: PhotoViewComputedScale.contained * 1,
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.covered * 4.1,
                        heroAttributes: PhotoViewHeroAttributes(tag: photo),
                      );
                    },
                    itemCount: widget.photoPaths?.length ?? 0,
                    backgroundDecoration: const BoxDecoration(color: backgroundColor),
                    pageController: _pageController,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
