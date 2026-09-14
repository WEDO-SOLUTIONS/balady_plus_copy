part of 'poi_makkah_widget_page.dart';

class _MakkahPoiPhotosHeaderDummy extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final int objectId;
  final List<String> photoUrls;

  const _MakkahPoiPhotosHeaderDummy({
    required this.objectId,
    required this.photoUrls,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(
    BuildContext context,
    PoiCardBottomSheetState state,
    double interpolation,
  ) {
    final photosEmpty = photoUrls.isEmpty;
    const photosAreLoading = false;

    final photosSizeTransform = _transformPhotoSize(
      state,
      interpolation,
      photosEmpty: photosEmpty,
      photosAreLoading: photosAreLoading,
    );
    final topHeaderHeightTransform = min(
      1.0,
      photosSizeTransform / HeaderComponent.photosMinHeight,
    );

    final showPhotos = !photosEmpty || photosAreLoading;

    return Directionality(
      textDirection: photosEmpty ? TextDirection.ltr : Directionality.of(context),
      child: Opacity(
        opacity: _resolveOpacity(state, interpolation),
        child: Align(
          heightFactor: topHeaderHeightTransform,
          alignment: photosEmpty ? AlignmentDirectional.topStart : Alignment.topCenter,
          child: Padding(
            padding: _topHeaderPaddingDelegate(
              state,
              interpolation,
              showPhotos: !showPhotos,
            ),
            child: Builder(
              builder: (context) {
                if (showPhotos) {
                  return SizedBox(
                    height: photosSizeTransform,
                    child: _MakkahDummyPhotosRow(
                      state: state,
                      interpolation: interpolation,
                      photoUrls: photoUrls,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  double _resolveOpacity(PoiCardBottomSheetState state, double interpolation) {
    final opacity = switch (state) {
      PoiCardBottomSheetState.hidden => Curves.easeIn.transform(interpolation),
      PoiCardBottomSheetState.halfOpen => 1.0,
      PoiCardBottomSheetState.open => 1 - Curves.easeIn.transform(interpolation),
      PoiCardBottomSheetState.expanded => 0.0,
    };
    return opacity.clamp(0, 1);
  }

  double _transformPhotoSize(
    PoiCardBottomSheetState state,
    double interpolation, {
    required bool photosEmpty,
    required bool photosAreLoading,
  }) {
    if (state == PoiCardBottomSheetState.hidden || state == PoiCardBottomSheetState.expanded) {
      return HeaderComponent.photosMinHeight * interpolation;
    }

    final hidePhotos = photosEmpty && !photosAreLoading;
    if (hidePhotos && state == PoiCardBottomSheetState.halfOpen) {
      return HeaderComponent.photosMinHeight * (1 - interpolation);
    }
    if (hidePhotos && state == PoiCardBottomSheetState.open) {
      return 0.0;
    }

    return MathHelper.lerpBetween(
      state.index + interpolation,
      HeaderComponent.photosMinHeight,
      _makkahPhotosMaxHeight,
      PoiCardBottomSheetState.halfOpen.index.toDouble(),
      PoiCardBottomSheetState.open.index.toDouble(),
    );
  }

  EdgeInsets _topHeaderPaddingDelegate(
    PoiCardBottomSheetState state,
    double interpolation, {
    bool showPhotos = true,
  }) {
    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return EdgeInsets.zero;
    }
    if (state == PoiCardBottomSheetState.hidden) {
      return EdgeInsets.only(
        bottom: Spacing.$3x,
        top: showPhotos ? 0.0 : Spacing.$3x,
      );
    }

    return EdgeInsets.only(
      bottom: Spacing.$3x * (1 - interpolation),
      top: showPhotos ? 0.0 : Spacing.$3x,
    );
  }
}

class _MakkahDummyPhotosRow extends StatelessWidget {
  final PoiCardBottomSheetState state;
  final double interpolation;
  final List<String> photoUrls;

  const _MakkahDummyPhotosRow({
    required this.state,
    required this.interpolation,
    required this.photoUrls,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusTop = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: RadiusBorder.ml,
      finalValue: RadiusBorder.ml,
      expandedValue: 0,
    );
    final borderRadiusBottom = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: RadiusBorder.ml,
      finalValue: 0,
    );
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(borderRadiusTop),
      topRight: Radius.circular(borderRadiusTop),
      bottomLeft: Radius.circular(borderRadiusBottom),
      bottomRight: Radius.circular(borderRadiusBottom),
    );

    final separatorWidth = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: 6.0,
      finalValue: 0,
      curve: Curves.easeInExpo,
    );
    final padding = _interpolation(
      state: state,
      interpolation: interpolation,
      initialValue: Spacing.$3x,
      finalValue: 0,
    );

    Widget itemBuilder(BuildContext context, int index) {
      final url = photoUrls[index % photoUrls.length];
      return GestureDetector(
        onTap: () {
          context.router.push(
            PhotoViewerRoute(
              photoPaths: photoUrls,
              currentPhotoIndex: index,
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, __) => ColoredBox(color: context.colors.backgroundSurface3),
          errorWidget: (_, __, ___) => ColoredBox(color: context.colors.backgroundSurface3),
        ),
      );
    }

    if (photoUrls.length == 1) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: itemBuilder(context, 0),
        ),
      );
    }

    if (photoUrls.length <= 3) {
      return LayoutBuilder(
        builder: (context, constraints) => PoiPhotosStories(
          itemCount: photoUrls.length,
          state: state,
          interpolation: interpolation,
          builder: (scrollController, physics) => ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            key: ValueKey(photoUrls.length),
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: borderRadius,
              child: AspectRatio(
                aspectRatio: _calculateFewAspectRatio(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  itemCount: photoUrls.length,
                  padding: padding,
                  separatorWidth: separatorWidth,
                ),
                child: itemBuilder(context, index),
              ),
            ),
            itemCount: photoUrls.length,
            physics: physics,
            separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
          ),
        ),
      );
    }

    return PoiPhotosStories(
      itemCount: photoUrls.length,
      state: state,
      interpolation: interpolation,
      builder: (scrollController, physics) => ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: padding),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: borderRadius,
          child: AspectRatio(
            key: ValueKey(photoUrls.length),
            aspectRatio: _getManyAspectRatio(
              context: context,
              state: state,
              interpolation: interpolation,
            ),
            child: itemBuilder(context, index),
          ),
        ),
        itemCount: min(photoUrls.length, 10),
        scrollDirection: Axis.horizontal,
        physics: physics,
        separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
      ),
    );
  }

  double _calculateFewAspectRatio({
    required double width,
    required double height,
    required int itemCount,
    required double padding,
    required double separatorWidth,
  }) {
    var aspectRatio = (width - 2 * padding - separatorWidth * (itemCount - 1)) / height;
    if (state == PoiCardBottomSheetState.hidden) {
      aspectRatio = ((width - 2 * padding - separatorWidth * (itemCount - 1)) / itemCount) / height;
    } else if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      aspectRatio = width / _makkahPhotosMaxHeight;
    } else {
      final paddings = 2 * padding + separatorWidth * (itemCount - 1);
      final interpolation = 1 - this.interpolation;
      aspectRatio = (width - paddings * interpolation) / (1 + (itemCount - 1) * interpolation);
      aspectRatio = aspectRatio / height;
    }

    if (aspectRatio > double.maxFinite || aspectRatio <= 0) {
      return 1;
    }
    return aspectRatio;
  }

  double _getManyAspectRatio({
    required BuildContext context,
    required PoiCardBottomSheetState state,
    required double interpolation,
  }) {
    if (state == PoiCardBottomSheetState.hidden) {
      return 1;
    }
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final finalAspectRatio = width / _makkahPhotosMaxHeight;

    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return finalAspectRatio;
    }

    return (finalAspectRatio - 1) * interpolation + 1;
  }

  double _interpolation({
    required double initialValue,
    required double finalValue,
    required PoiCardBottomSheetState state,
    required double interpolation,
    double? expandedValue,
    Curve? curve,
  }) {
    if (state == PoiCardBottomSheetState.hidden) {
      return initialValue;
    }

    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return expandedValue ?? finalValue;
    }

    return (finalValue - initialValue) * (curve?.transform(interpolation) ?? interpolation) + initialValue;
  }
}
