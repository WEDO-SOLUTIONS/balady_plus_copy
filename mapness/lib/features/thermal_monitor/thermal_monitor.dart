import 'dart:async';
import 'dart:convert';

import 'package:mapness/features/thermal_monitor/data/thermal_config.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/app_config_loader.dart';
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

    ThermalConfig config;
    try {
      config = ThermalConfig.fromJson(jsonDecode((await AppConfigLoader.getThermalStatusData()) ?? ''));
    } catch (_) {
      config = ThermalConfig.initial;
    }

    logger.log(
      'Thermal monitor activated with config: $config',
      logLevel: MapnessLogLevel.info,
    );

    final stream = MergeStream([
      thermal.thermalStatus.asStream(),
      thermal.onThermalStatusChanged,
    ]);

    final subscription = stream.listen((thermalStatus) async {
      final int? fps;
      final MapnessLogLevel logLevel;

      switch (thermalStatus) {
        case ThermalStatus.none:
          fps = config.idleTemperature;
          logLevel = MapnessLogLevel.verbose;
        case ThermalStatus.light:
          fps = config.lightTemperature;
          logLevel = MapnessLogLevel.info;
        case ThermalStatus.moderate:
          fps = config.moderateTemperature;
          logLevel = MapnessLogLevel.warning;
        case ThermalStatus.severe:
          fps = config.severeTemperature;
          logLevel = MapnessLogLevel.warning;
        case ThermalStatus.emergency:
        case ThermalStatus.shutdown:
        case ThermalStatus.critical:
          fps = config.criticalTemperature;
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
