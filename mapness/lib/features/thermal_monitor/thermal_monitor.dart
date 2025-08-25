import 'dart:async';

import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thermal/thermal.dart';

part 'thermal_monitor.g.dart';

@Riverpod(keepAlive: true)
class ThermalMonitor extends _$ThermalMonitor {
  @override
  Future<void> build() async {
    final thermal = Thermal();

    final controller = await ref.watch(dgisControllerProvider.future);

    final stream = MergeStream([
      thermal.thermalStatus.asStream(),
      thermal.onThermalStatusChanged,
    ]);

    final subscription = stream.listen((thermalStatus) async {
      final int? fps;
      final MapnessLogLevel logLevel;

      switch (thermalStatus) {
        case ThermalStatus.none:
          fps = null;
          logLevel = MapnessLogLevel.verbose;
        case ThermalStatus.light:
          fps = 30;
          logLevel = MapnessLogLevel.info;
        case ThermalStatus.moderate:
          fps = 20;
          logLevel = MapnessLogLevel.warning;
        case ThermalStatus.severe:
          fps = 15;
          logLevel = MapnessLogLevel.warning;
        case ThermalStatus.emergency:
        case ThermalStatus.shutdown:
        case ThermalStatus.critical:
          fps = 10;
          logLevel = MapnessLogLevel.warning;
      }

      logger.log(
        'Received thermal status - $thermalStatus, selected fps - $fps',
        logLevel: logLevel,
      );

      await controller.setMaxFps(fps);
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }
}
