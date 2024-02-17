import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'package:timelines/timelines.dart';

class RouteTimeline extends StatelessWidget {
  const RouteTimeline({
    super.key,
    required this.labels,
  });

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return FixedTimeline(
      theme: TimelineTheme.of(context).copyWith(
        nodePosition: 0,
        indicatorPosition: 0.5,
        connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
              thickness: 2.0,
            ),
      ),
      children: labels
          .mapIndexed(
            (index, element) => RouteTimelineRow(
              index: index,
              last: index == labels.length - 1,
              point: element,
            ),
          )
          .toList(),
    );
  }
}

class RouteTimelineRow extends StatelessWidget {
  const RouteTimelineRow({
    super.key,
    required this.last,
    required this.index,
    required this.point,
  });

  final int index;
  final bool last;
  final String point;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      contents: Padding(
        padding: EdgeInsets.only(
          right: 8,
          bottom: last ? 0 : 4,
        ),
        child: Text(
          point,
          style: Theme.of(context).extension<ThemeTextStyles>()!.textS.copyWith(
              color: index == 0
                  ? context.color.text_and_icons_base_tertiary
                  : context.color.text_and_icons_base_primary),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      node: TimelineNode(
        // indicatorPosition: 0.5,
        indicator: SvgPicture.asset(
          "assets/icons/svg/ic_routing_circle_small.svg",
          package: PackageConfig.packageName,
          colorFilter: ColorFilter.mode(
            index == 0 ? const Color(0xFF52B374) : context.color.stroke_accent,
            BlendMode.srcATop,
          ),
        ),
        startConnector: index == 0
            ? null
            : const SolidLineConnector(
                color: Color(0x261E2A36),
                endIndent: 2,
              ),
        endConnector: last
            ? null
            : const SolidLineConnector(
                color: Color(0x261E2A36),
                indent: 2,
              ),
      ),
    );
  }
}
