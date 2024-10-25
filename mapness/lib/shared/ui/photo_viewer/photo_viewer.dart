import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

@RoutePage()
class PhotoViewerPage extends StatefulWidget {
  final List<String>? photoPaths;
  final int currentPhotoIndex;

  const PhotoViewerPage({
    required this.photoPaths,
    required this.currentPhotoIndex,
    super.key,
  });

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  static const backgroundColor = Color(0xff0B1218);
  String _title = '';
  late final PhotoViewController _scaleController;
  late PageController pageController;
  late ValueNotifier<bool> isAppBarVisible;

  @override
  void initState() {
    super.initState();
    _scaleController = PhotoViewController()
      // We skip first event because the first event is send when the page is loaded
      // But we don't want to hide UI from the start
      ..outputStateStream.skip(1).listen(listener);
    pageController = PageController(initialPage: widget.currentPhotoIndex);
    isAppBarVisible = ValueNotifier(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _title = getTitle(widget.currentPhotoIndex);
      });
    });
  }

  @override
  void didUpdateWidget(covariant PhotoViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _title = getTitle(widget.currentPhotoIndex);
  }

  void listener(PhotoViewControllerValue value) {
    // According to design we need to hide UI on the zoom
    isAppBarVisible.value = false;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: isAppBarVisible,
        builder: (context, isAppBarVisible, child) => Material(
          color: backgroundColor,
          child: Material(
            color: Colors.transparent,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: isAppBarVisible
                  // TODO: Update when BaladyTopBar starts supporting background color
                  ? _PhotoAppBar(title: _title)
                  : null,
              body: child,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => isAppBarVisible.value = !isAppBarVisible.value,
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
                        controller: _scaleController,
                      );
                    },
                    itemCount: widget.photoPaths?.length ?? 0,
                    backgroundDecoration: const BoxDecoration(color: backgroundColor),
                    pageController: pageController,
                    allowImplicitScrolling: true,
                    onPageChanged: (i) {
                      setState(() {
                        _title = getTitle(i);
                      });
                    }),
              ],
            ),
          ),
        ),
      );

  String getTitle(int currentIndex) {
    final photoNumber = [(currentIndex + 1).toString(), context.l10n.wordOf, widget.photoPaths?.length.toString()];
    if (context.isRTL) {
      photoNumber.reversed;
    }
    return photoNumber.join(' ');
  }
}

const _appBarBackground = [
  Color.fromRGBO(0, 0, 0, 0.6),
  Color.fromRGBO(0, 0, 0, 0.45),
  Color.fromRGBO(0, 0, 0, 0.24),
  Color.fromRGBO(0, 0, 0, 0),
];

class _PhotoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const _PhotoAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.maxFinite,
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _appBarBackground,
              ),
            ),
          ),
          BaladyTopBar(
            textStyle: context.textStyle.callout.copyWith(color: Colors.white),
            title: title,

            /// TODO(ui_kit): Fix leading in UIKIT
            leading: Container(
              padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
              alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
              child: const Icon(
                SystemIcons.arrowCornerLeftSmall,
                color: Colors.white,
                size: 24,
              ),
            ),
            onLeadingPressed: () => context.router.maybePop(),
          ),
        ],
      );

  @override
  Size get preferredSize => const Size(double.maxFinite, 140);
}
