import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../navi/pedestrian_contoller.dart';

/// Graph widget with altitudes for pedestian route
class PedestrianBarWidget extends StatelessWidget {
  const PedestrianBarWidget({
    required this.controller,
    super.key,
  });

  final NaviPedestrianController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BarChartGroupData>>(
        valueListenable: controller.state,
        builder: (_, data, __) {
          return BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              maxY: maxBarValue,
              barGroups: data,
            ),
          );
        });
  }
}
