import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';

const debugStyleAttributeCustomVehicleMarkersOn = 'customVehicleMarkersOn';
const debugStyleAttributeVehicleMarkerType = 'vehicleMarkerType';

const debugVehicleMarkerTypeNone = '';
const debugVehicleMarkerTypeJeep = 'jeep';
const debugVehicleMarkerTypeBuhanka = 'buhanka';
const debugVehicleMarkerTypeCarFly = 'carFly';
const debugVehicleMarkerTypeCarSport = 'carSport';
const debugVehicleMarkerTypeUtkaDefault = 'utkaDefault';
const debugVehicleMarkerTypeUtkaJetpack = 'utkaJetpack';

const debugVehicleMarkerTypeControls = [
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeNone,
    title: 'None',
    subtitle: 'vehicleMarkerType is empty',
  ),
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeJeep,
    title: 'Jeep',
    subtitle: 'vehicleMarkerType=jeep',
  ),
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeBuhanka,
    title: 'Buhanka',
    subtitle: 'vehicleMarkerType=buhanka',
  ),
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeCarFly,
    title: 'Car Fly',
    subtitle: 'vehicleMarkerType=carFly',
  ),
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeCarSport,
    title: 'Car Sport',
    subtitle: 'vehicleMarkerType=carSport',
  ),
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeUtkaDefault,
    title: 'Utka',
    subtitle: 'vehicleMarkerType=utkaDefault',
  ),
  DebugVehicleMarkerTypeControl(
    value: debugVehicleMarkerTypeUtkaJetpack,
    title: 'Utka Jetpack',
    subtitle: 'vehicleMarkerType=utkaJetpack',
  ),
];

final debugStyleAttributesProvider = NotifierProvider<DebugStyleAttributes, DebugStyleAttributesState>(
  DebugStyleAttributes.new,
);

class DebugVehicleMarkerTypeControl {
  const DebugVehicleMarkerTypeControl({
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final String value;
  final String title;
  final String subtitle;
}

class DebugStyleAttributesState {
  const DebugStyleAttributesState({
    required this.customVehicleMarkersOn,
    required this.vehicleMarkerType,
  });

  final bool customVehicleMarkersOn;
  final String vehicleMarkerType;

  bool get hasSelectedVehicleMarker => vehicleMarkerType.isNotEmpty;

  DebugStyleAttributesState copyWith({
    bool? customVehicleMarkersOn,
    String? vehicleMarkerType,
  }) => DebugStyleAttributesState(
    customVehicleMarkersOn: customVehicleMarkersOn ?? this.customVehicleMarkersOn,
    vehicleMarkerType: vehicleMarkerType ?? this.vehicleMarkerType,
  );
}

class DebugStyleAttributes extends Notifier<DebugStyleAttributesState> {
  @override
  DebugStyleAttributesState build() {
    ref.listen<AsyncValue<DgisMapController>>(dgisControllerProvider, (previous, next) {
      final controller = next.value;
      if (controller == null) {
        return;
      }

      detach(_applyAttributes(controller, state), tag: 'debugStyleAttributes.applyAttributes');
    });

    return _defaultState();
  }

  Future<void> setCustomVehicleMarkersOn({required bool value}) async {
    state = state.copyWith(customVehicleMarkersOn: value);

    final controller = ref.read(dgisControllerProvider).value;
    await controller?.setMapAttributeBool(debugStyleAttributeCustomVehicleMarkersOn, value: value);
  }

  Future<void> setVehicleMarkerType(String value) async {
    state = state.copyWith(vehicleMarkerType: value);

    final controller = ref.read(dgisControllerProvider).value;
    await controller?.setMapAttributeString(debugStyleAttributeVehicleMarkerType, value: value);
  }

  Future<void> resetAll() async {
    final defaultState = _defaultState();
    state = defaultState;

    final controller = ref.read(dgisControllerProvider).value;
    if (controller == null) {
      return;
    }

    await _applyAttributes(controller, defaultState);
  }

  DebugStyleAttributesState _defaultState() => const DebugStyleAttributesState(
    customVehicleMarkersOn: false,
    vehicleMarkerType: debugVehicleMarkerTypeNone,
  );

  Future<void> _applyAttributes(DgisMapController controller, DebugStyleAttributesState state) async {
    await controller.setMapAttributeBool(
      debugStyleAttributeCustomVehicleMarkersOn,
      value: state.customVehicleMarkersOn,
    );
    await controller.setMapAttributeString(debugStyleAttributeVehicleMarkerType, value: state.vehicleMarkerType);
  }
}
