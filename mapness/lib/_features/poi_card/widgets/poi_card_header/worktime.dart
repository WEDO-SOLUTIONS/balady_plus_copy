import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/poi_card/enums/poi_card_bottom_sheet_state.dart';

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
    if (state != PoiCardBottomSheetState.halfOpen) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$3x),
      child: Text(
        worktime,
        style: context.textStyle.footNoteBold.copyWith(
          color: context.color.textAndIconsBaseSecondary.withAlpha(125),
        ),
      ),
    );
  }
}
