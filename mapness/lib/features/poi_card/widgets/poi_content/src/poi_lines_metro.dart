import 'package:balady_uikit/balady_uikit.dart' hide PoiContentWorkTime, PoiContentWorkTimeDay;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

/// A widget that renders a metro route with its platforms for a given POI (Point of Interest).
///
/// This widget displays the name of the route (e.g., metro line name) as an expandable section.
/// Inside, it shows a vertical list of platforms (stations) on that route,
/// including transition icons if the platform connects to other lines.
///
/// Each platform is rendered with a custom vertical metro line using [_StationLinePainter],
/// visually connecting all stops and highlighting the currently active one.
///
/// Example usage:
/// ```dart
/// PoiLinesMetro(
///   transportDirectoryRouteInfo: routeInfo,
///   address: currentStationName,
/// );
/// ```
class PoiLinesMetro extends StatelessWidget {
  final PublicTransportDirectoryRouteInfoMessage transportDirectoryRouteInfo;
  final String address;

  const PoiLinesMetro({
    required this.transportDirectoryRouteInfo,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _platformsInfo = transportDirectoryRouteInfo.directions.firstOrNull?.platforms ?? [];
    final _colorLine = Color(transportDirectoryRouteInfo.color ?? Colors.black.value);

    return ContentWrapper(
      color: context.color.surfaceBasePrimary,
      children: [
        ContentRowExpandable(
          expandIconColor: context.colorsV3.foregroundMuted,
          // ignore: deprecated_member_use
          options: ContentRowOptions(
            title: transportDirectoryRouteInfo.name,
            leadingIcon: Assets.icons.svg.icMetroMarker.svg(
              colorFilter: ColorFilter.mode(_colorLine, BlendMode.srcIn),
            ),
          ),
          content: Column(
            children: List.generate(_platformsInfo.length, (index) {
              final transitionRoute = _platformsInfo[index].transitions;
              final routeCurrent = _platformsInfo[index].name == address;
              return CustomPaint(
                painter: _StationLinePainter(
                  isFirst: index == 0,
                  isLast: index == _platformsInfo.length - 1,
                  isSelected: routeCurrent,
                  color: _colorLine,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 40),
                      Text(
                        _platformsInfo[index].name,
                        style: context.textStyleV3.bodyLargeRegular
                      ),
                      if (transitionRoute.isNotEmpty)
                        Row(
                          children: transitionRoute
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(left: Spacing.px),
                                  child: Assets.icons.svg.icMetroMarker.svg(
                                    colorFilter: ColorFilter.mode(Color(e.color ?? 0xFF000000), BlendMode.srcIn),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// A custom painter used to draw the vertical metro line and circular station indicators.
///
/// This painter is used in [PoiLinesMetro] to visually represent the metro route
/// with a vertical line connecting stations and a highlighted circle for the current station.
///
/// It draws:
/// - A vertical line above and below the station (if not first or last).
/// - A circle representing the station.
/// - Larger circle and higher opacity if the station is selected.
class _StationLinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final Color color;

  _StationLinePainter({
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double lineX = 20.0;
    const double dotRadius = 6.0;
    const double spacing = 2.0;

    final double centerY = size.height / 2;

    final double topY = centerY - dotRadius - spacing;
    final double bottomY = centerY + dotRadius + spacing;

    final Paint linePaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2;

    if (!isFirst) {
      canvas.drawLine(const Offset(lineX, 0), Offset(lineX, topY), linePaint);
    }

    if (!isLast) {
      canvas.drawLine(Offset(lineX, bottomY), Offset(lineX, size.height), linePaint);
    }

    final Paint dotPaint = Paint()
      ..color = color.withOpacity(isSelected ? 1.0 : 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(lineX, centerY), isSelected ? 8.0 : 4.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _StationLinePainter oldDelegate) =>
      oldDelegate.isFirst != isFirst || oldDelegate.isLast != isLast || oldDelegate.isSelected != isSelected;
}
