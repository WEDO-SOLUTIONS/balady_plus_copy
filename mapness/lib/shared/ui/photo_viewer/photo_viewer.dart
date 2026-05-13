import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/photo_viewer/custom_scroll_physics.dart';
import 'package:mapness/shared/ui/photo_viewer/photo_view_pager.dart';

@RoutePage()
class PhotoViewerPage extends StatefulWidget {
  final List<String>? photoPaths;
  final List<String>? previewUrls;
  final int currentPhotoIndex;

  const PhotoViewerPage({
    required this.photoPaths,
    required this.currentPhotoIndex,
    this.previewUrls,
    super.key,
  });

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  static const backgroundColor = Color(0xff0B1218);
  final ValueNotifier<String> title = ValueNotifier('');
  late PageController pageController;
  late ValueNotifier<bool> isAppBarVisible;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.currentPhotoIndex,
    );
    pageController.addListener(updateTitle);
    isAppBarVisible = ValueNotifier(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      title.value = getTitle(widget.currentPhotoIndex);
    });
  }

  @override
  void didUpdateWidget(covariant PhotoViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    title.value = getTitle(widget.currentPhotoIndex);
  }

  void updateTitle() {
    title.value = getTitle(pageController.page?.round() ?? 0);
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
                  ? _PhotoAppBar(title: title)
                  : null,
              body: child,
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: backgroundColor),
          child: PhotoViewPager(
            imageSource: widget.photoPaths ?? [],
            imagePreviews: widget.previewUrls ?? [],
            scrollPhysics: CustomScrollPhysics.common(),
            doubleTapZoomable: true,
            pageController: pageController,
            showTitleBar: (show) {
              setState(() {
                isAppBarVisible.value = show;
              });
            },
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
  final ValueNotifier<String> title;

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
          ValueListenableBuilder(
            valueListenable: title,
            builder: (context, value, _) => BaladyTopBar(
              textStyle: context.textStyle.callout.copyWith(color: Colors.white),
              title: value,

              /// TODO(ui_kit): Fix leading in UIKIT
              leading: Semantics(
                label: context.l10n.a11yBack,
                button: true,
                child: ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
                    alignment: context.isLTR ? Alignment.centerLeft : Alignment.centerRight,
                    child: const Icon(
                      SystemIcons.arrowCornerLeftSmall,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              onLeadingPressed: () => context.router.pop(),
            ),
          ),
        ],
      );

  @override
  Size get preferredSize => const Size(double.maxFinite, 140);
}
