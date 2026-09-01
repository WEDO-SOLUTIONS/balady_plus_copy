import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:urbi_utils/urbi_utils.dart';

class ReportRoadEventLanes extends StatefulHookConsumerWidget {
  final Set<RoadEventLane>? selectedLanes;
  final ValueChanged<Set<RoadEventLane>>? onUpdate;

  const ReportRoadEventLanes({super.key, this.selectedLanes, this.onUpdate});

  @override
  ConsumerState<ReportRoadEventLanes> createState() => _ReportRoadEventLanesState();
}

class _ReportRoadEventLanesState extends ConsumerState<ReportRoadEventLanes> {
  final _selectedLanes = <RoadEventLane>{};

  @override
  void initState() {
    super.initState();
    _selectedLanes
      ..clear()
      ..addAll(widget.selectedLanes ?? {});
  }

  @override
  void didUpdateWidget(covariant ReportRoadEventLanes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLanes != widget.selectedLanes) {
      _selectedLanes
        ..clear()
        ..addAll(widget.selectedLanes ?? {});
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        widget.selectedLanes != null ? context.l10n.roadEventAffectedLanes : context.l10n.roadEventWhichLane,
        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
      ),
      const SizedBox(height: Spacing.$3x),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: RoadEventLane.values
            .map<Widget>(
              (e) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onUpdate != null ? () => _onLaneSelected(e) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$8x, vertical: 7),
                  child: _LaneItem(isSelected: _selectedLanes.contains(e)),
                ),
              ),
            )
            .insertBetween(
              CustomPaint(
                size: const Size(2, 50),
                painter: DashedLinePainter(color: context.colors.foregroundSoft),
              ),
            )
            .toList(),
      ),
    ],
  );

  void _onLaneSelected(RoadEventLane lane) {
    final enable = !_selectedLanes.contains(lane);

    setState(() {
      if (enable) {
        _selectedLanes.add(lane);
      } else {
        _selectedLanes.remove(lane);
      }
    });
    widget.onUpdate?.call(_selectedLanes);
  }
}

class _LaneItem extends StatelessWidget {
  final bool isSelected;

  const _LaneItem({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return EventsOnTheRoute.alertCircleSolid.icon(size: 36, color: context.colors.errorDefault);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(width: 1.50, color: context.colors.foregroundSoft),
        shape: BoxShape.circle,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  const DashedLinePainter({
    required this.color,
    this.dashHeight = 8,
    this.dashGap = 8,
    this.strokeWidth = 1.5,
    super.repaint,
  });

  final Color color;
  final double dashHeight;
  final double dashGap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final x = size.width / 2;
    var y = 0.0;
    while (y < size.height) {
      final endY = y + dashHeight > size.height ? size.height : y + dashHeight;
      canvas.drawLine(Offset(x, y), Offset(x, endY), paint);
      y += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) =>
      color != oldDelegate.color ||
      dashHeight != oldDelegate.dashHeight ||
      dashGap != oldDelegate.dashGap ||
      strokeWidth != oldDelegate.strokeWidth;
}
