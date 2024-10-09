import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/road_events/ui/widgets/closure_card.dart';
import 'package:mapness/features/road_events/ui/widgets/closure_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';

class RoadClosurePage extends ConsumerStatefulWidget {
  const RoadClosurePage({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.finishTime,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final DgisObjectId id;
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? finishTime;
  final double latitude;
  final double longitude;

  static final DateFormat _dateFormatShort = DateFormat('dd.MM.yyyy H:mm');
  static final DateFormat _dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  @override
  ConsumerState<RoadClosurePage> createState() => _RoadClosurePageState();
}

class _RoadClosurePageState extends ConsumerState<RoadClosurePage> {
  @override
  void initState() {
    super.initState();
    unawaited(selectEvent());
  }

  @override
  void activate() {
    super.activate();
    unawaited(selectEvent());
  }

  @override
  void deactivate() {
    unawaited(removeSelection());
    super.deactivate();
  }

  Future<void> selectEvent() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.setHighlighted([
      widget.id.toMessage(),
    ]);
  }

  Future<void> removeSelection() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.setHighlighted([]);
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Expanded(child: ClosureControls()),
          ClosureCard(
            // TODO(@alexstrnik) switch back to widget.title after SDK fix
            title: context.l10n.roadBlocking,
            description: widget.description,
            workDuration: _formatSchedule(widget.startTime, widget.finishTime),
          ),
        ],
      );

  String? _formatSchedule(DateTime? from, DateTime? to) {
    if (from == null) {
      return null;
    }

    var schedule =
        from.hour > 10 ? RoadClosurePage._dateFormat.format(from) : RoadClosurePage._dateFormatShort.format(from);
    if (to != null) {
      schedule +=
          ' – ${to.hour > 10 ? RoadClosurePage._dateFormat.format(to) : RoadClosurePage._dateFormatShort.format(to)}';
    }

    return schedule;
  }
}
