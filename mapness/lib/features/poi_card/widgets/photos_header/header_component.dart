import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photos_row.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/header.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:sheetify/multi_state_sheet/animated_state_components/sheet_base_components.dart';
import 'package:urbi_utils/urbi_utils.dart';

class HeaderComponent extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  static const photosMinHeight = 96.0;
  static const photosMaxHeight = 216 + PoiHeader.poiHeaderBorderRadius;

  final bool photosAreLoading;
  final int objectId;
final int photosCount;
  const HeaderComponent({
    required this.photosCount,
    required this.photosAreLoading,
    required this.objectId,
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final photosSizeTransform = _transformPhotoSize(state, interpolation);
final topHeaderHeightTransform = min(1.0, photosSizeTransform / photosMinHeight);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final isItParkingSpot = objectId == parkingObjectId;
    final photosEmpty = photosCount == 0;
    final showPhotos = !photosEmpty || photosAreLoading || isItParkingSpot;

    final fitWidth = photosCount == 1;

    return Directionality(
      textDirection: photosEmpty ? TextDirection.ltr : Directionality.of(context),
      child: Opacity(
        opacity: _resolveOpacity(state, interpolation),
        child: Padding(
          padding: topHeaderPaddingDelegate(state, interpolation, showPhotos: !showPhotos),
          child: Builder(
            builder: (context) {
              if (showPhotos) {
                return SizedBox(
height: photosSizeTransform,
                  width: fitWidth ? screenWidth : null,
                  child: PoiPhotosRow(
                    objectId: objectId,
                    state: state,
                    interpolation: interpolation,
                  ),
                );
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    innerPadding: const EdgeInsetsDirectional.only(
                      start: Spacing.$2x + Spacing.$0_5x,
                      end: Spacing.$3x + Spacing.$0_5x,
                    ),
                    buttonColorScheme: ButtonColorScheme.accent,
                    buttonType: ButtonType.secondary,
                    onTap: () => context.router.push(QuickFeedbackPhotoRoute(params: FeedbackObjectIdParams(objectId))),
                    primaryIcon: GeneralIcons.photoSolid,
                    primaryLabel: context.l10n.addPhoto,
                    color: context.colors.backgroundSurface2,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _resolveOpacity(PoiCardBottomSheetState state, double interpolation) {
    final opacity = switch (state) {
      PoiCardBottomSheetState.hidden => Curves.easeIn.transform(interpolation),
      PoiCardBottomSheetState.halfOpen => 1.0,
      PoiCardBottomSheetState.open => 1.0,
      PoiCardBottomSheetState.expanded => 1.0,
    };
    return opacity.clamp(0, 1);
  }

  double _transformPhotoSize(PoiCardBottomSheetState state, double interpolation) {
    if (state == PoiCardBottomSheetState.hidden) {
      return photosMinHeight * interpolation;
    }

    final _parkingObjectId = objectId == parkingObjectId;

    final hidePhotos = photosCount == 0 && !photosAreLoading && !_parkingObjectId;
    if (hidePhotos && state == PoiCardBottomSheetState.halfOpen) {
      return photosMinHeight * (1 - interpolation);
    }
    if (hidePhotos && state == PoiCardBottomSheetState.open) {
      return 0.0;
    }

    // Use max height when open or expanded
    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return photosMaxHeight;
    }

    return MathHelper.lerpBetween(
      state.index + interpolation,
      photosMinHeight,
      photosMaxHeight,
      PoiCardBottomSheetState.halfOpen.index.toDouble(),
      PoiCardBottomSheetState.open.index.toDouble(),
    );
  }

  EdgeInsets topHeaderPaddingDelegate(PoiCardBottomSheetState state, double interpolation, {bool showPhotos = true}) {
    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return EdgeInsets.zero;
    }
    if (state == PoiCardBottomSheetState.hidden) {
      return EdgeInsets.only(bottom: Spacing.$2x, top: showPhotos ? 0.0 : Spacing.$2x);
    }

    return EdgeInsets.only(bottom: Spacing.$2x * (1 - interpolation), top: showPhotos ? 0.0 : Spacing.$2x);
  }
}
