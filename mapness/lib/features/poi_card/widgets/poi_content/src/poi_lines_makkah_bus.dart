import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/makkah_bus/makkah_bus_departures_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/date_time_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

class PoiLinesMakkahBus extends StatefulWidget {
  final MakkahBusRoute routeInfo;

  const PoiLinesMakkahBus({required this.routeInfo, super.key});

  @override
  State<PoiLinesMakkahBus> createState() => _PoiLinesMakkahBusState();
}

class _PoiLinesMakkahBusState extends State<PoiLinesMakkahBus> {
  final format = DateFormat('hh:mm a');

  int getMinutesFromDepartureTime(String departureTime) {
    final now = DateTime.now();

    final parsedTime = format.parse(departureTime);
    final departureDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    final difference = departureDateTime.difference(now);
    return difference.inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final colorLine = widget.routeInfo.routeColor.toColor() ?? context.colorsV3.foregroundDefault;
    final textColorLine = widget.routeInfo.routeTextColor.toColor() ?? context.colorsV3.foregroundDefault;
    final l10n = context.l10n;
    final trips = widget.routeInfo.trips
        .where(
          (element) => getMinutesFromDepartureTime(element.departureTime) >= 0,
        )
        .toList();
    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      children: [
        ContentRowExpandable(
          expandIconColor: context.colors.foregroundMuted,
          options: ContentRowOptions(
            leadingIcon: Icon(
              Icons.directions_bus_filled_sharp,
              color: colorLine,
              size: 24,
            ),
            titleBuilder: (context) => Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.routeInfo.headsign,
                    style: TextStyle(
                      color: context.colors.foregroundDefault,
                      fontSize: 16,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$0_5x, horizontal: Spacing.$1x),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Spacing.$0_5x),
                        color: colorLine,
                      ),
                      margin: const EdgeInsetsDirectional.only(start: Spacing.$1x),
                      child: Text(
                        widget.routeInfo.routeShortName,
                        style: TextStyle(color: textColorLine, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          content: Column(
            children: List.generate(trips.length, (index) {
              final trip = trips[index];
              final isDelayed = trip.delaySeconds > 0 ;
              final delayedTime = format.format(format.parse(trip.departureTime).add(Duration(seconds: trip.delaySeconds)));
              final inMinutes = getMinutesFromDepartureTime(isDelayed?delayedTime:trip.departureTime);

              return CustomPaint(
                painter: _TripLinePainter(
                  isFirst: index == 0,
                  isLast: index == trips.length - 1,
                  color: colorLine,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
                  child: Row(
                    children: [
                      const SizedBox(width: Spacing.$10x),
                      Text(
                        trip.departureTime,
                        style: context.textStyleV3.bodyLargeRegular.copyWith(
                          color: context.colors.foregroundDefault,
                          decoration: isDelayed ? TextDecoration.lineThrough : null,
                          fontSize: 14,
                        ),
                      ),
                      if (isDelayed)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: Spacing.$1x),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_forward, size: 14, color: colorLine),
                              const SizedBox(width: Spacing.$1x),
                              Text(
                                delayedTime,
                                style: context.textStyleV3.bodyLargeRegular.copyWith(
                                  color: context.colors.successDefault,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      if (!inMinutes.isNegative && inMinutes >= 0 && inMinutes < 60)
                        Text(
                          inMinutes == 0 ? l10n.ready : l10n.minLeft(inMinutes),
                          style: context.textStyleV3.bodyLargeRegular.copyWith(
                            color: inMinutes == 0 ? context.colors.successDefault : context.colors.foregroundMuted,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(width: Spacing.$4x),
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
      oldDelegate.isFirst != isFirst || oldDelegate.isLast != isLast || oldDelegate.color != color;
}
