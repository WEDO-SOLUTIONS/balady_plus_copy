import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/makkah_bus/makkah_bus_departures_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

class PoiLinesMakkahBus extends StatelessWidget {
  final MakkahBusRoute routeInfo;

  const PoiLinesMakkahBus({required this.routeInfo, super.key});

  @override
  Widget build(BuildContext context) {
    // Try to parse color from hex string like "214C9B"
    Color colorLine;
    try {
      colorLine = Color(int.parse('FF${routeInfo.routeColor}', radix: 16));
    } catch (_) {
      colorLine = context.colorsV3.foregroundDefault;
    }

    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      children: [
        ContentRowExpandable(
          expandIconColor: context.colors.foregroundMuted,
          // ignore: deprecated_member_use
          options: ContentRowOptions(
            title: '${routeInfo.routeShortName} - ${routeInfo.headsign}',
            leadingIcon: Icon(
              Icons.directions_bus_filled_sharp,
              color: colorLine,
              size: 24,
            ),
          ),
          content: Column(
            children: List.generate(routeInfo.trips.length, (index) {
              final trip = routeInfo.trips[index];
              return CustomPaint(
                painter: _TripLinePainter(
                  isFirst: index == 0,
                  isLast: index == routeInfo.trips.length - 1,
                  color: colorLine,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 40),
                      Text(
                        trip.departureTime,
                        style: context.textStyleV3.bodyLargeRegular.copyWith(
                          color: context.colors.foregroundDefault,
                        ),
                      ),
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

class _TripLinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  _TripLinePainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double lineX = 20.0;
    const double dotRadius = 4.0;
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
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(lineX, centerY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _TripLinePainter oldDelegate) =>
      oldDelegate.isFirst != isFirst ||
      oldDelegate.isLast != isLast ||
      oldDelegate.color != color;
}
