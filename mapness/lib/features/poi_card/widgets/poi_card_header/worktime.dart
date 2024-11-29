import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';

class WorktimeComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final String worktime;

  const WorktimeComponent({
    required this.worktime,
    super.key,
  }) : super(
          defaultState: PoiCardBottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    var scale = interpolation;
    if (state == PoiCardBottomSheetState.halfOpen) {
      scale = 1 - interpolation;
    }
    if (state.index >= PoiCardBottomSheetState.open.index) {
      scale = 0;
    }
    return ContentTransition(
      interpolation: scale,
      child: Padding(
        padding: const EdgeInsets.only(top: Spacing.$3x, bottom: Spacing.$3x),
        child: Text(
          worktime,
          style: context.textStyle.footNoteBold.copyWith(
            color: context.color.textAndIconsBaseSecondary.withAlpha(125),
          ),
        ),
      ),
    );
  }
}
