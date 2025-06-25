import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';

/// This widget have to be a wrapper of header of the StatefulBottomSheet
/// The main thing is that we use [BottomSheetStateComponent] so it should be a child of
/// the BottomSheet
/// Also if you want it to work you have to set [displayDragger] in [StatefulBottomSheet] to false and add
/// Dragger by yourself inside header
///
/// We can expand this widget to support more than one line of text or different widgets inside the header
class HeaderInfoWrapper extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final Widget child;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isVisible;
  final double borderRadius;

  const HeaderInfoWrapper({
    required this.child,
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.isVisible = true,
    this.borderRadius = RadiusBorder.xl,
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    if (!isVisible) {
      return child;
    }
    final backgroundColor = this.backgroundColor ?? context.colorsV3.errorContainerDefault;
    final textColor = this.textColor ?? context.colorsV3.errorOnContainer;
    return Column(
      children: [
        ColoredBox(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: SizedBox(
              height: _interpolation(state, interpolation, 26),
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      text,
                      style: context.textStyleV3.bodySmallRegular.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ColoredBox(
          color: backgroundColor,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  double _interpolation(PoiCardBottomSheetState state, double interpolation, double maxValue) {
    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return 0;
    }
    if (state == PoiCardBottomSheetState.hidden) {
      return maxValue;
    }

    return maxValue * (1 - interpolation);
  }
}
