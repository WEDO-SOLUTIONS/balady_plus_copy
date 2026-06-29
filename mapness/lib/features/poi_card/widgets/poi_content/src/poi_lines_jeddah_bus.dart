import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/bus/model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class PoiLinesJeddahBus extends StatelessWidget {
  final BusStation station;
  final List<BusLine>? lines;

  const PoiLinesJeddahBus({
    required this.station,
    required this.lines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lines = this.lines;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$3x),
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(Spacing.$4x),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                TransportIcons.bus,
                size: 24,
                color: context.colors.foregroundDefault,
              ),
              Spacing.$3x.widthBox,
              Text(
                context.l10n.jeddahBus,
                style: context.textStyles.bodyLargeSemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
            ],
          ),
          if (lines != null) ...[
            Spacing.$3x.heightBox,
            Column(
              spacing: Spacing.$1_5x,
              children: lines.map((e) => _ExpandableLine(station, e)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpandableLine extends ConsumerWidget {
  final BusStation station;
  final BusLine line;

  const _ExpandableLine(this.station, this.line);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.read(appLanguageProvider);

    final routeNameShort = switch (lang) {
      Language.english => line.routeShortNameEn,
      Language.arabic => line.routeShortNameAr,
    };
    final routeNameFull = switch (lang) {
      Language.english => line.routeLongNameEn,
      Language.arabic => line.routeLongNameAr,
    };

    return ContentWrapper(
      color: context.colors.backgroundSurface5,
      children: [
        ContentRowExpandable(
          expandIconColor: line.stations.isEmpty ? Colors.transparent : context.colors.foregroundMuted,
          options: ContentRowOptions(
            titleBuilder: (context) => Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: line.flutterColor,
                    borderRadius: BorderRadius.circular(Spacing.$1x),
                    border: Border.all(color: context.colors.foregroundDefault),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 24,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    routeNameShort,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacing.$1_5x.widthBox,
                Text(
                  routeNameFull,
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(top: Spacing.$2x),
            child: _LineStationList(station, line),
          ),
        ),
      ],
    );
  }
}

class _LineStationList extends StatelessWidget {
  final BusStation station;
  final BusLine line;

  const _LineStationList(this.station, this.line);

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Column(
        children: line.stations
            .map(
              (station) => _LineStationListItem(
                station,
                line.flutterColor,
                isCurrent: this.station.stationId == station.stationId,
              ),
            )
            .toList(),
      ),
      PositionedDirectional(
        start: 14.5,
        top: 0,
        bottom: 0,
        child: CustomPaint(
          painter: _DashedLinePainter(
            color: context.colors.foregroundDefault,
            startY: 34,
            dashGap: 5 * 2 + 13,
            dashHeight: 21,
            thickness: 1,
          ),
        ),
      ),
    ],
  );
}

class _LineStationListItem extends ConsumerWidget {
  final BusStation station;
  final Color color;
  final bool isCurrent;

  const _LineStationListItem(this.station, this.color, {required this.isCurrent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.read(appLanguageProvider);

    final stationName = switch (lang) {
      Language.english => station.nameEn,
      Language.arabic => station.nameAr,
    };

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: Spacing.$3x).copyWith(start: Spacing.$2x),
     // height: 44,
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.foregroundDefault),
            ),
          ),
          const SizedBox(width: 17),
          Text(
            stationName,
            style: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.foregroundDefault,
              fontWeight: isCurrent ? FontWeight.w600 : null,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double startY;
  final double thickness;
  final double dashHeight;
  final double dashGap;

  _DashedLinePainter({
    required this.color,
    required this.startY,
    required this.thickness,
    required this.dashHeight,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startY = this.startY;
    while (startY < size.height) {
      // Ensure the last dash doesn't overflow the canvas bounds
      final endY = startY + dashHeight;
      if (endY > size.height) {
        break;
      }

      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, endY), paint);
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! _DashedLinePainter ||
      color != oldDelegate.color ||
      startY != oldDelegate.startY ||
      thickness != oldDelegate.thickness ||
      dashHeight != oldDelegate.dashHeight ||
      dashGap != oldDelegate.dashGap;
}
