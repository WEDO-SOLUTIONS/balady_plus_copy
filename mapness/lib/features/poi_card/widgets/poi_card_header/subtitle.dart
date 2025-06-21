import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';

class SubtitleComponent extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final String subtitle;
  final List<InlineSpan> inlineSpans;
  final IconData? subtitleIcon;
  final PublicTransportDirectoryRouteInfoMessage? routeInfo;
  final String? title;

  const SubtitleComponent({
    required this.subtitle,
    this.title,
    this.routeInfo,
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

    final currentRoute = routeInfo?.directions.firstOrNull?.platforms.firstWhereOrNull((e) => e.name == title);
    final color = Color(routeInfo?.color ?? Colors.black.value);
    final platformsAndTransitions = currentRoute?.transitions
        .map(
          (e) => Row(
            children: [
              Spacing.$1x.widthBox,
              Assets.icons.svg.icMetroMarker.svg(
                colorFilter: ColorFilter.mode(Color(e.color ?? Colors.black.value), BlendMode.srcIn),
              ),
              Spacing.$1x.widthBox,
            ],
          ),
        )
        .toList();

    return ContentTransition(
      interpolation: scale,
      child: Row(
        children: [
          if (currentRoute != null)
            Assets.icons.svg.icMetroMarker.svg(colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          if (currentRoute != null) Spacing.$1x.widthBox,
          ...?platformsAndTransitions,
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
