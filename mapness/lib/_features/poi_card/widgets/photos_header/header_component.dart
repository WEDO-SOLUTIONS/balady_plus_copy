import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_row.dart';

const minHeight = 100.0;
const maxHeight = 150.0;
const xMin = 0.1;
const xMax = 1.0;

class HeaderComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final bool isPhotosNotEmpty;
  final int objectId;
  final ValueNotifier<double> aspectRatio;

  const HeaderComponent({
    required this.isPhotosNotEmpty,
    required this.objectId,
    required this.aspectRatio,
    super.key,
  }) : super(
          defaultState: PoiCardBottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) => Opacity(
        opacity: _resolveOpacity(state, interpolation),
        child: ValueListenableBuilder<double>(
          builder: (ctx, val, child) => SizedBox(
            height: isPhotosNotEmpty ? 0.0 : _transformPhotoSize(val),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: Spacing.$3x,
              ),
              child: PoiPhotosRow(
                objectId: objectId,
              ),
            ),
          ),
          valueListenable: aspectRatio,
        ),
      );

  double _resolveOpacity(PoiCardBottomSheetState state, double interpolation) {
    final opacity = switch (state) {
      PoiCardBottomSheetState.hidden => interpolation * 2 - 1,
      PoiCardBottomSheetState.halfOpen => 1.0,
      PoiCardBottomSheetState.open => 1 - interpolation * 2,
      PoiCardBottomSheetState.expanded => 0.0,
    };
    return opacity.clamp(0, 1);
  }

  double _transformPhotoSize(double x) {
    const xMin = 0.1;
    const xMax = 1.0;

    if (x < xMin || x > xMax) {
      return minHeight;
    }
    final y = minHeight + ((maxHeight - minHeight) / (xMax - xMin)) * (x - xMin);
    return max(minHeight, min(y, maxHeight));
  }
}
