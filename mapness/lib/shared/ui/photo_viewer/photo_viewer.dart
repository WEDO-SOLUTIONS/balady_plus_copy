import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PhotoViewerWidget extends StatefulWidget {
  final List<String>? photoPaths;
  final int currentPhotoIndex;

  const PhotoViewerWidget({
    required this.photoPaths,
    required this.currentPhotoIndex,
    super.key,
  });

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> {
  static const backgroundColor = Color(0xff0B1218);
  String _title = '';
  late PageController pageController;
  late ValueNotifier<bool> isAppBarVisible;
  late final MultiImageProvider multiImageProvider;

  @override
  void initState() {
    super.initState();
    multiImageProvider = MultiImageProvider(widget.photoPaths?.map((path) => NetworkImage(path)).toList() ?? []);
    pageController = PageController(initialPage: widget.currentPhotoIndex);
    pageController.addListener(updateTitle);
    isAppBarVisible = ValueNotifier(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _title = getTitle(widget.currentPhotoIndex);
      });
    });
  }

  @override
  void didUpdateWidget(covariant PhotoViewerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _title = getTitle(widget.currentPhotoIndex);
  }

  void updateTitle() {
    setState(() {
      _title = getTitle(pageController.page?.round() ?? 0);
    });
  }

  @override
  void dispose() {
    pageController.removeListener(updateTitle);
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
        child: DecoratedBox(
          decoration: const BoxDecoration(color: backgroundColor),
          child: Stack(
            children: [
              EasyImageViewPager(
                easyImageProvider: multiImageProvider,
                pageController: pageController,
                doubleTapZoomable: true,
                onScaleChanged: (zoom) {
                  if (zoom > 1) {
                    isAppBarVisible.value = false;
                  } else {
                    isAppBarVisible.value = true;
                  }
                },
              ),
            ],
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
            onLeadingPressed: () => context.pop(),
          ),
        ],
      );

  @override
  Size get preferredSize => const Size(double.maxFinite, 140);
}
