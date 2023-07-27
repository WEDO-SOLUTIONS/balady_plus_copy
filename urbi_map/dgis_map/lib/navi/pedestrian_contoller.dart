import 'dart:async';
import 'dart:math';

import 'package:dgis_map/library.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Limit of altitude bars
const _maxBarsCount = 68;

/// Max height of each bar. This is logical value - neither pixels nor dps.
const maxBarValue = 100.0;

/// Controller with data for pedestian route
class NaviPedestrianController {
  NaviPedestrianController(this.events);

  final Stream<RouteChangedEvent> events;

  final state = ValueNotifier(<BarChartGroupData>[]);

  StreamSubscription? _subscription;

  void init() {
    _subscription = events.listen((event) {
      final altitudes = event.altitudes;

      if (altitudes.isEmpty) {
        state.value = <BarChartGroupData>[];
        return;
      }

      final count = max(altitudes.length, _maxBarsCount);
      final maxValue = altitudes.reduce((l, r) => max(l, r));
      final minValue = altitudes.reduce((l, r) => min(l, r));

      final data = <BarChartGroupData>[];
      for (var i = 1; i <= count; i++) {
        // Projection from [0..altitudes.length] to [0..count]
        var prj = ((altitudes.length) * i / count).floor();
        if (prj <= 0) prj = 1;
        if (prj >= altitudes.length) prj = altitudes.length - 1;

        // Projection from [minValue..maxValue] to [0..100]
        final value =
            maxBarValue / (maxValue - minValue) * (altitudes[prj] - minValue);

        data.add(BarChartGroupData(
          x: prj,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: _getColor(altitudes[prj], altitudes[prj - 1]),
              width: 1,
            ),
          ],
        ));
      }

      state.value = data;
    });
  }

  void dispose() {
    unawaited(_subscription?.cancel());
  }

  Color _getColor(int l, int r) {
    if (l == r) return Colors.yellow;

    if (l > r) return Colors.red;

    return Colors.green;
  }
}
