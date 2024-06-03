import 'package:balady_uikit/balady_uikit.dart';
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

  ///Using Navigator instead of Gorouter for prevent rebuild underlying page
  static Future<Object?> open(
    BuildContext context,
    int currentPhotoIndex,
    List<String> photoPaths,
  ) {
    final navigatorState = Navigator.of(context);
    return navigatorState.push(
      MaterialPageRoute(
        builder: (ctx) => PhotoViewer(
          currentPhotoIndex: currentPhotoIndex,
          photoPaths: photoPaths,
        ),
      ),
    );
  }

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  static const backgroundColor = Color(0xff0B1218);

  late PageController pageController;
  late ValueNotifier<bool> isAppBarVisible;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.currentPhotoIndex);
    isAppBarVisible = ValueNotifier(true);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: isAppBarVisible,
        builder: (context, isAppBarVisible, child) => Material(
          color: backgroundColor,
          child: Material(
            color: isAppBarVisible
                ? context.color.surfaceContrastHigh
                : Colors.transparent,
            child: Scaffold(
              appBar: isAppBarVisible
                  // TODO: Update when BaladyTopBar starts supporting background color
                  ? BaladyTopBar(
                      textStyle: context.textStyle.callout
                          .copyWith(color: Colors.white),
                      title: context.l10n.photos,

                      /// TODO(ui_kit): Fix leading in UIKIT
                      leading: Container(
                        padding: const EdgeInsetsDirectional.only(
                            start: NumericBase.$4x),
                        alignment: context.isLTR
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Icon(
                          context.isLTR
                              ? SystemIcons.arrowCornerLeftSmall
                              : SystemIcons.arrowCornerRightSmall,
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
          onTap: () => isAppBarVisible.value = !isAppBarVisible.value,
          child: Padding(
            padding: const EdgeInsets.only(top: NumericBase.$4x),
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
                        minScale: PhotoViewComputedScale.contained *
                            (0.5 + index / 10),
                        maxScale: PhotoViewComputedScale.covered * 4.1,
                        heroAttributes: PhotoViewHeroAttributes(tag: photo),
                      );
                    },
                    itemCount: widget.photoPaths?.length ?? 0,
                    backgroundDecoration:
                        const BoxDecoration(color: backgroundColor),
                    pageController: pageController,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
