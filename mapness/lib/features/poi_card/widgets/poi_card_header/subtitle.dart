import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';
import 'package:sheetify/sheetify.dart';

class SubtitleComponent extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final String subtitle;
  final List<InlineSpan> inlineSpans;
  final IconData? subtitleIcon;
  final List<PublicTransportDirectoryRouteInfoMessage?>? routeInfo;
  final String? title;

  const SubtitleComponent({
    required this.subtitle,
    this.title,
    this.routeInfo,
    this.subtitleIcon,
    this.inlineSpans = const [],
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    final subTitleTextStyle = context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft);

    var scale = interpolation;
    if (state == PoiCardBottomSheetState.hidden) {
      scale = 1.0;
    } else if (state.index >= PoiCardBottomSheetState.halfOpen.index) {
      scale = 1;
    }

    return ContentTransition(
      interpolation: scale,
      child: Row(
        children: [
          if (routeInfo != null)
            ...?routeInfo?.map(
              (e) => Row(
                children: [
                  Assets.icons.svg.icMetroMarker.svg(
                    colorFilter: ColorFilter.mode(
                      Color(e?.color ?? context.colors.foregroundDefault.value),
                      BlendMode.srcIn,
                    ),
                  ),
                  Spacing.$1x.widthBox,
                ],
              ),
            ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    subtitle,
                    style: subTitleTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(
                      height: 1.6 * scale,
                      forceStrutHeight: true,
                    ),
                  ),
                ),
                ...inlineSpans.map((span) {
                  if (span is WidgetSpan) {
                    return span.child;
                  }
                  if (span is TextSpan) {
                    return RichText(
                      text: TextSpan(
                        text: span.text,
                        children: span.children,
                        style: span.style?.merge(subTitleTextStyle) ?? subTitleTextStyle,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
          if (subtitleIcon != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: Spacing.$1x),
              child: Icon(subtitleIcon, color: context.colors.foregroundSoft, size: 24),
            ),
        ],
      ),
    );
  }
}
