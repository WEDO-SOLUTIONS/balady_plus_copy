import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/poi_photos_header.dart';
import 'package:mapness/features/poi_card/widgets/poi_photos_row.dart';
import 'package:urbi_utils/urbi_utils.dart';

class HeaderComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final bool isPhotosNotEmpty;
  final int objectId;

  const HeaderComponent({
    required this.isPhotosNotEmpty,
    required this.objectId,
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final transformPhotoSize = _transformPhotoSize(state, interpolation);
    final hideTransform = min(1.0, transformPhotoSize / photosMinHeight);

    return Opacity(
      opacity: _resolveOpacity(state, interpolation),
      child: Align(
        heightFactor: hideTransform,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Spacing.$3x),
          child: SizedBox(
            height: isPhotosNotEmpty ? 0.0 : transformPhotoSize,
            child: PoiPhotosRow(
              objectId: objectId,
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
    if (state == PoiCardBottomSheetState.hidden) {
      return photosMinHeight * interpolation;
    }
    return MathHelper.lerpBetween(state.index + interpolation, photosMinHeight, photosMaxHeight,
        PoiCardBottomSheetState.halfOpen.index.toDouble(), PoiCardBottomSheetState.open.index.toDouble());
  }
}
