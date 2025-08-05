import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';

class TitleComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final String title;

  const TitleComponent({
    required this.title,
    super.key,
  }) : super(
          defaultState: PoiCardBottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) => Text(
        title,
        style: context.textStyles.h2SemiBold.copyWith(
          color: context.color.textAndIconsBasePrimary,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: state != PoiCardBottomSheetState.hidden ? 2 : 1,
        textAlign: TextAlign.start,
      );
}
