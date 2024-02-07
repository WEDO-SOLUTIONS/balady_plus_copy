// ignore_for_file: prefer_expression_function_bodies

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/road_events/ui/widgets/closure_controls.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

import 'widgets/closure_card.dart';

const _roadClosuresName = 'road-closures';

class RoadClosurePage extends ConsumerStatefulWidget {
  const RoadClosurePage({
    required this.title,
    required this.description,
    required this.startTime,
    required this.finishTime,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? finishTime;
  final double latitude;
  final double longitude;

  static final DateFormat _dateFormat = DateFormat('yyyy MMM dd HH:mm');

  @override
  ConsumerState<RoadClosurePage> createState() => _RoadClosurePageState();
}

class _RoadClosurePageState extends ConsumerState<RoadClosurePage> {
  @override
  Widget build(BuildContext context) {
    ref.watch(
      mapObjectManagerProvider(named: _roadClosuresName),
    );
    ref.read(mapObjectManagerProvider(named: _roadClosuresName).notifier)
      ..removeAllMarkers()
      ..addMarker(
        Markers.pinMarker(
          GeoPointWithElevationMessage(
            latitude: widget.latitude,
            longitude: widget.longitude,
            elevation: 0,
          ),
          id: 'closure-${widget.latitude}-${widget.longitude}',
          width: 48,
          icon: 'packages/mapness/assets/icons/svg/ic_map_closure.svg',
        ),
      );

    return Column(
      children: [
        const Expanded(
          child: ClosureControls(),
        ),
        ClosureCard(
          title: widget.title,
          description: widget.description,
          workDuration: _formatSchedule(widget.startTime, widget.finishTime),
        )
      ],
    );
  }

  String? _formatSchedule(DateTime? from, DateTime? to) {
    if (from == null) {
      return null;
    }

    String schedule = RoadClosurePage._dateFormat.format(from);
    if (to != null) {
      schedule += ' – ${RoadClosurePage._dateFormat.format(to)}';
    }

    return schedule;
  }
}
