part of 'poi_photo_row_builder.dart';

class _PoiPhotoFew extends StatelessWidget {
  final double padding;
  final double separatorWidth;
  final PoiCardBottomSheetState? state;
  final double? interpolation;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final BorderRadius borderRadius;

  const _PoiPhotoFew({
    required this.itemBuilder,
    required this.borderRadius,
    required this.padding,
    required this.separatorWidth,
    required this.itemCount,
    this.interpolation,
    this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (context, constraints) => PoiPhotosStories(
          key: key,
          itemCount: itemCount,
          state: state,
          interpolation: interpolation,
          builder:
              (scrollController, physics) => ListView.separated(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                key: ValueKey(itemCount),
                padding: EdgeInsets.symmetric(horizontal: padding),
                itemBuilder:
                    (context, index) => ClipRRect(
                      borderRadius: borderRadius,
                      child: AspectRatio(
                        aspectRatio: _calculateAspectRatio(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                        child: itemBuilder(context, index),
                      ),
                    ),
                itemCount: itemCount,
                physics: physics,
                separatorBuilder:
                    (context, index) => SizedBox(width: separatorWidth),
              ),
        ),
  );

  double _calculateAspectRatio(double width, double height) {
    var aspectRatio =
        (width - 2 * padding - separatorWidth * (itemCount - 1)) / height;
    if (state == PoiCardBottomSheetState.hidden) {
      aspectRatio =
          ((width - 2 * padding - separatorWidth * (itemCount - 1)) /
              itemCount) /
          height;
    } else if (state == PoiCardBottomSheetState.open ||
        state == PoiCardBottomSheetState.expanded) {
      aspectRatio = width / HeaderComponent.photosMaxHeight;
    } else {
      final paddings = 2 * padding + separatorWidth * (itemCount - 1);
      final interpolation = 1 - (this.interpolation ?? 0);
      aspectRatio =
          (width - paddings * interpolation) /
          (1 + (itemCount - 1) * interpolation);
      aspectRatio = aspectRatio / height;
    }

    if (aspectRatio > double.maxFinite) {
      aspectRatio = 1;
    } else if (aspectRatio <= 0) {
      aspectRatio = 1;
    }

    return aspectRatio;
  }
}
