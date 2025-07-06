part of 'poi_photo_row_builder.dart';

class _PoiPhotoMany extends StatelessWidget {
  final double padding;
  final double separatorWidth;
  final PoiCardBottomSheetState? state;
  final double? interpolation;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final BorderRadius borderRadius;

  const _PoiPhotoMany({
    required this.itemBuilder,
    required this.borderRadius,
    required this.padding,
    required this.separatorWidth,
    required this.itemCount,
    this.state,
    this.interpolation,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PoiPhotosStories(
        key: key,
        itemCount: itemCount,
        state: state,
        interpolation: interpolation,
        builder: (scrollController, physics) => ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: padding),
          itemBuilder: (context, index) => ClipRRect(
            borderRadius: borderRadius,
            child: AspectRatio(
              key: ValueKey(itemCount),
              aspectRatio: _getPhotoAspectRatio(context, state, interpolation),
              child: itemBuilder(context, index),
            ),
          ),
          itemCount: min(itemCount, 10),
          scrollDirection: Axis.horizontal,
          physics: physics,
          separatorBuilder: (_, index) => SizedBox(width: separatorWidth),
        ),
      );

  double _getPhotoAspectRatio(BuildContext context, PoiCardBottomSheetState? state, double? interpolation) {
    if (state == null || interpolation == null) {
      return 1;
    }

    if (state == PoiCardBottomSheetState.hidden) {
      return 1;
    }
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final finalAspectRatio = width / HeaderComponent.photosMaxHeight;

    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return finalAspectRatio;
    }

    return (finalAspectRatio - 1) * interpolation + 1;
  }
}
