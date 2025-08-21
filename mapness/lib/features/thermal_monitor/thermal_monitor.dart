import 'dart:async';

import 'package:mapness/shared/providers/map/dgis_controller.dart';
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
      switch(thermalStatus) {
        case ThermalStatus.none:
          fps = null;
        case ThermalStatus.light:
          fps = 30;
        case ThermalStatus.moderate:
          fps = 20;
        case ThermalStatus.severe:
          fps = 15;
        case ThermalStatus.critical:
          fps = 10;
        case ThermalStatus.emergency:
        case ThermalStatus.shutdown:
          return;
      }

      await controller.setMaxFps(fps);
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }
}
