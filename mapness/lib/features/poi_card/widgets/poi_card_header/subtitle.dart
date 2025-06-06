import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';

class SubtitleComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final String subtitle;
  final List<InlineSpan> inlineSpans;
  final IconData? subtitleIcon;

  const SubtitleComponent({
    required this.subtitle,
    this.subtitleIcon,
    this.inlineSpans = const [],
    super.key,
  }) : super(
          defaultState: PoiCardBottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final subTitleTextStyle = context.textStyle.footNote.copyWith(
      color: context.color.textAndIconsBaseSecondary,
    );

    var scale = interpolation;
    if (state.index >= PoiCardBottomSheetState.halfOpen.index) {
      scale = 1;
    }

    return ContentTransition(
      interpolation: scale,
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(text: subtitle, children: inlineSpans),
              style: subTitleTextStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
          ),
          if (subtitleIcon != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: Spacing.$1x),
              child: Icon(
                subtitleIcon,
                color: context.color.textAndIconsBaseSecondary,
                size: 24,
              ),
            )
        ],
      ),
    );
  }
}
