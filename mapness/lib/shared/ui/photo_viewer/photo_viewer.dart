import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerWidget extends StatefulWidget {
  const PhotoViewerWidget({
    required this.photoPaths,
    required this.currentPhotoIndex,
    super.key,
  });
  final List<String>? photoPaths;
  final int currentPhotoIndex;

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> {
  static const backgroundColor = Color(0xff0B1218);

  int _currentPage = 0;

  late PageController pageController;
  late ValueNotifier<bool> isAppBarVisible;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.currentPhotoIndex);
    isAppBarVisible = ValueNotifier(true);

    _currentPage = widget.currentPhotoIndex;
    pageController.addListener(() {
      final newPage = pageController.page?.round() ?? 0;

      setState(() {
        _currentPage = newPage;
      });
    });
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: isAppBarVisible,
        builder: (context, isAppBarVisible, child) => Material(
          color: backgroundColor,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                child ?? const SizedBox(),
                if (isAppBarVisible)
                  Positioned(
                    top: 0,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: BaladyTopBar(
                      textStyle: context.textStyle.callout.copyWith(color: Colors.white),
                      title: '${_currentPage + 1} ${context.l10n.wordOf} ${widget.photoPaths?.length}',
                      leading: Container(
                        padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
                        alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
                        child: Icon(
                          context.isLTR ? SystemIcons.arrowCornerLeftLarge : SystemIcons.arrowCornerRightLarge,
                          color: Colors.white,
                        ),
                      ),
                      onLeadingPressed: () => context.pop(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => isAppBarVisible.value = !isAppBarVisible.value,
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
                    pageController: pageController,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
