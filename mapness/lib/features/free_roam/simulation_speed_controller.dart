import 'dart:async';

import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'simulation_speed_controller.g.dart';

/// Navigation simulation speed in km/h. On change it is pushed to the active map
/// via [DgisMapController.simulationSpeed] (converted to m/s). Shared by the debug
/// sheet's speed slider and the on-map camera HUD so they stay in sync.
@Riverpod(keepAlive: true)
class SimulationSpeed extends _$SimulationSpeed {
  @override
  double build() => 70;

  Future<void> setKmh(double kmh) async {
    state = kmh;
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.simulationSpeed(kmh / 3.6);
  }
}
