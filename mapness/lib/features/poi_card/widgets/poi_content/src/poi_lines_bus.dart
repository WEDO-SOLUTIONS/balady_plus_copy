import 'dart:async';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/bus_departures/model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/date_time_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class PoiLinesMakkahBus extends ConsumerStatefulWidget {
  final BusRoute routeInfo;
  final bool isShuttle;

  const PoiLinesMakkahBus({required this.routeInfo, this.isShuttle = false, super.key});

  @override
  ConsumerState<PoiLinesMakkahBus> createState() => _PoiLinesMakkahBusState();
}

class _PoiLinesMakkahBusState extends ConsumerState<PoiLinesMakkahBus> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int getMinutesFromDepartureTime(String departureTime) {
    final appLanguage = ref.read(appLanguageProvider);
    final format = DateFormat('hh:mm a');
    final now = DateTime.now();

    final parsedTime = format.parse(departureTime.replaceAll('ص', 'AM').replaceAll('م', 'PM').trim());
    var departureDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    if (departureDateTime.isBefore(now)) {
      departureDateTime = departureDateTime.add(const Duration(days: 1));
    }
    final difference = departureDateTime.difference(now);
    final minutes = (difference.inSeconds / 60).ceil();
    return minutes;
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = ref.read(appLanguageProvider);
    final colorLine = widget.routeInfo.routeColor.toColor() ?? context.colorsV3.foregroundDefault;
    final textColorLine = widget.routeInfo.routeTextColor.toColor() ?? context.colorsV3.foregroundDefault;
    final l10n = context.l10n;
    final trips = widget.routeInfo.trips.where((trip) {
      final inMinutes = getMinutesFromDepartureTime(
        trip.departureTimeUpdate ?? trip.departureTime,
      );
      return inMinutes < 1380;
    }).toList();
    return ContentWrapper(
      color: context.colors.backgroundSurface5,
      children: [
        ContentRowExpandable(
          expandIconColor: trips.isEmpty ? Colors.transparent : colorLine,
          options: ContentRowOptions(
            titleBuilder: (context) => Text.rich(
              TextSpan(
                children: [
                  if (widget.isShuttle)
                    TextSpan(
                      text: '${l10n.from}\t\t',
                      style: context.textStyles.bodyLargeMedium.copyWith(
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
                      margin: const EdgeInsetsDirectional.only(end: Spacing.$1x),
                      child: Text(
                        widget.routeInfo.routeShortName,
                        style: context.textStyles.bodyLargeMedium.copyWith(color: textColorLine, fontSize: 12),
                      ),
                    ),
                  ),
                  if (widget.isShuttle)
                    TextSpan(
                      text: '${l10n.to}\n',
                      style: context.textStyles.bodyLargeMedium.copyWith(
                        color: context.colors.foregroundDefault,
                        fontSize: 14,
                      ),
                    ),
                  TextSpan(
                    text: widget.routeInfo.headsign,
                    style: context.textStyles.bodyLargeMedium.copyWith(
                      color: context.colors.foregroundDefault,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          content: Column(
            children: List.generate(trips.length, (index) {
              final trip = trips[index];
              final isDelayed = trip.departureTimeUpdate != null;
              final inMinutes = getMinutesFromDepartureTime(
                isDelayed && trip.departureTimeUpdate != null ? trip.departureTimeUpdate! : trip.departureTime,
              );

              return CustomPaint(
                painter: _TripLinePainter(
                  isFirst: index == 0,
                  isLast: index == trips.length - 1,
                  color: colorLine,
                  isArabic: appLanguage.isArabic,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
                  child: Row(
                    children: [
                      const SizedBox(width: Spacing.$10x),
                      Text(
                        context.digits(trip.departureTime),
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
                                context.digits(trip.departureTimeUpdate!),
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
                          inMinutes == 0 ? l10n.ready : l10n.digits(l10n.minLeft(inMinutes)),
                          style: context.textStyleV3.bodyLargeRegular.copyWith(
                            color: isDelayed && !trip.delaySeconds.isNegative && inMinutes != 0
                                ? context.colors.errorDefault
                                : context.colors.successDefault,
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
  final bool isArabic;

  _TripLinePainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
    required this.isArabic,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double dotRadius = 4.0;
    const double spacing = 2.0;
    final double lineX = isArabic ? size.width - 20.0 : 20.0;

    final double centerY = size.height / 2;
    final double topY = centerY - dotRadius - spacing;
    final double bottomY = centerY + dotRadius + spacing;

    final Paint linePaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2;

    if (!isFirst) {
      canvas.drawLine(Offset(lineX, 0), Offset(lineX, topY), linePaint);
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
      oldDelegate.color != color ||
      oldDelegate.isArabic != isArabic;
}
