import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/poi_photos_header.dart';
import 'package:mapness/features/poi_card/widgets/poi_photos_row.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:urbi_utils/urbi_utils.dart';

class HeaderComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final bool isPhotosEmpty;
  final bool isPhotosLoading;
  final int objectId;

  const HeaderComponent({
    required this.isPhotosEmpty,
    required this.isPhotosLoading,
    required this.objectId,
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final transformPhotoSize = _transformPhotoSize(state, interpolation);
    final hideTransform = min(1.0, transformPhotoSize / photosMinHeight);
    final _parkingObjectId = objectId == parkingObjectId;

    final isNoPhotos = isPhotosEmpty && !isPhotosLoading && !_parkingObjectId;

    return Directionality(
      textDirection: isPhotosEmpty ? TextDirection.ltr : Directionality.of(context),
      child: Opacity(
        opacity: _resolveOpacity(state, interpolation),
        child: Align(
          heightFactor: hideTransform,
          alignment: isPhotosEmpty ? AlignmentDirectional.topStart : Alignment.topCenter,
          child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: Spacing.$4x, start: isNoPhotos ? Spacing.$3x : 0.0),
            child: isNoPhotos
                ? BaladyAppButton(
                    buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                    onTap: () => context.router.push(
                      QuickFeedbackPhotoRoute(
                        params: FeedbackObjectIdParams(objectId),
                      ),
                    ),
                    color: context.color.surfaceBasePrimary,
                    size: BaladyButtonSize.small,
                    primaryIcon: GeneralIcons.plusCircleFilled,
                    primaryLabel: context.l10n.addPhoto,
                    textColor: context.colorsV3.accentDefault,
                    iconColor: context.colorsV3.accentDefault,
                  )
                : SizedBox(
                    height: transformPhotoSize,
                    child: PoiPhotosRow(
                      objectId: objectId,
                    ),
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

  double _transformPhotoSize(PoiCardBottomSheetState state, double interpolation) {
    if (state == PoiCardBottomSheetState.hidden || state == PoiCardBottomSheetState.expanded) {
      return photosMinHeight * interpolation;
    }

    final _parkingObjectId = objectId == parkingObjectId;

    final isNoPhotos = isPhotosEmpty && !isPhotosLoading && !_parkingObjectId;
    if (isNoPhotos && state == PoiCardBottomSheetState.halfOpen) {
      return photosMinHeight * (1 - interpolation);
    }
    if (isNoPhotos && state == PoiCardBottomSheetState.open) {
      return 0.0;
    }

    return MathHelper.lerpBetween(state.index + interpolation, photosMinHeight, photosMaxHeight,
        PoiCardBottomSheetState.halfOpen.index.toDouble(), PoiCardBottomSheetState.open.index.toDouble());
  }
}
