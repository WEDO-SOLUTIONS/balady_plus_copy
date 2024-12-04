import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';

class HeaderAddressComponent
    extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final PoiContentFullAddress fullAddress;

  const HeaderAddressComponent({
    required this.fullAddress,
    super.key,
  }) : super(
          defaultState: PoiCardBottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state,
      double interpolation) {
    if (state == PoiCardBottomSheetState.hidden) {
      return const SizedBox.shrink();
    }
    var scale = interpolation;
    if (state == PoiCardBottomSheetState.expanded ||
        state == PoiCardBottomSheetState.open) {
      scale = 0;
    }

    return ContentTransition(
      interpolation: scale,
      child: ContentRow(
        options: ContentRowOptions(
          title: fullAddress.name,
          titleStyle: context.textStyle.callout,
          subtitle: fullAddress.address,
          subtitleStyle: context.textStyle.footNote,
          subtitleMaxlines: 99,
          actionWidget: ContentRowActionOptions(
            actionText: fullAddress.distance,
          ),
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
