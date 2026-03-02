import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:sheetify/sheetify.dart';

class TitleComponent extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final String title;

  const TitleComponent({required this.title, super.key}) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) => Text(
    title,
    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
    overflow: TextOverflow.ellipsis,
    maxLines: state != PoiCardBottomSheetState.hidden ? 2 : 1,
    textAlign: TextAlign.start,
  );
}
