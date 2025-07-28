import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photos_row.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/header.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:urbi_utils/urbi_utils.dart';

class HeaderComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  static const photosMinHeight = 96.0;
  static const photosMaxHeight = 156.0 + PoiHeader.poiHeaderBorderRadius;

  final bool photosEmpty;
  final bool photosAreLoading;
  final int objectId;

  const HeaderComponent({
    required this.photosEmpty,
    required this.photosAreLoading,
    required this.objectId,
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final photosSizeTransform = _transformPhotoSize(state, interpolation);
    final topHeaderHeightTransform = min(1.0, photosSizeTransform / photosMinHeight);
    final isItParkingSpot = objectId == parkingObjectId;

    final showPhotos = !photosEmpty || photosAreLoading || isItParkingSpot;

    return Directionality(
      textDirection: photosEmpty ? TextDirection.ltr : Directionality.of(context),
      child: Opacity(
        opacity: _resolveOpacity(state, interpolation),
        child: Align(
          heightFactor: topHeaderHeightTransform,
          alignment: photosEmpty ? AlignmentDirectional.topStart : Alignment.topCenter,
          child: Padding(
            padding: topHeaderPaddingDelegate(state, interpolation, showPhotos: !showPhotos),
            child: Builder(builder: (context) {
              if (showPhotos) {
                return SizedBox(
                  height: photosSizeTransform,
                  child: PoiPhotosRow(
                    objectId: objectId,
                    state: state,
                    interpolation: interpolation,
                  ),
                );
              }
              return AppButton(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                innerPadding: const EdgeInsetsDirectional.only(
                  start: Spacing.$2x + Spacing.$0_5x,
                  end: Spacing.$3x + Spacing.$0_5x,
                ),
                buttonColorScheme: ButtonColorScheme.accent,
                buttonType: ButtonType.secondary,
                onTap: () => context.router.push(
                  QuickFeedbackPhotoRoute(
                    params: FeedbackObjectIdParams(objectId),
                  ),
                ),
                primaryIcon: GeneralIcons.photoSolid,
                primaryLabel: context.l10n.addPhoto,
                color: context.colors.backgroundSurface2,
              );
            }),
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

  double _transformPhotoSize(PoiCardBottomSheetState state, double interpolation) {
    if (state == PoiCardBottomSheetState.hidden || state == PoiCardBottomSheetState.expanded) {
      return photosMinHeight * interpolation;
    }

    final _parkingObjectId = objectId == parkingObjectId;

    final hidePhotos = photosEmpty && !photosAreLoading && !_parkingObjectId;
    if (hidePhotos && state == PoiCardBottomSheetState.halfOpen) {
      return photosMinHeight * (1 - interpolation);
    }
    if (hidePhotos && state == PoiCardBottomSheetState.open) {
      return 0.0;
    }

    return MathHelper.lerpBetween(state.index + interpolation, photosMinHeight, photosMaxHeight,
        PoiCardBottomSheetState.halfOpen.index.toDouble(), PoiCardBottomSheetState.open.index.toDouble());
  }

  EdgeInsets topHeaderPaddingDelegate(PoiCardBottomSheetState state, double interpolation, {bool showPhotos = true}) {
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
