import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';
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
          style: PackageFonts.frutigerArabic(
            color:
                index == 0 ? const Color(0x801E2A36) : const Color(0xFF1E2A36),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
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
            index == 0 ? const Color(0xFF52B374) : const Color(0xFF4CA5B4),
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
