import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/lifestyle_layers/providers/parking_details.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_state.g.dart';

const parkingTypeKey = 'parking_type_key';
const String attributeParkingOn = 'parkingOn';
const String attributeParkingFilteredPaidOn = 'parking_filter_paid_on';
const String attributeParkingFilteredFreeOn = 'parking_filter_free_on';

@Riverpod(keepAlive: true)
class ParkingState extends _$ParkingState {
  @override
  ParkingStateEvent build() {
    final autoEnableParking = ref.read(navigatorAutoEnableParkingProvider);
    final controllerFuture = ref.read(dgisControllerProvider.future);

    ref.onDispose(
      () {
        detach(
          controllerFuture.then((controller) => controller.setMapAttributeBool(attributeParkingOn, value: false)),
          tag: 'parkingState.setMapAttributeBool',
        );
      },
    );

    return ParkingStateEvent(
      filter: ParkingFilter.all,
      visible: autoEnableParking ?? false,
    );
  }

  Future<void> showParking() async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (!ref.mounted) {
      return;
    }
    final prefs = ref.read(sharedPrefsProvider);
    final attribute = prefs.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;
    final activeLayersNotifier = ref.read(activeLayerProvider.notifier);

    await activeLayersNotifier.setActiveLayer(LayerType.parkingLots);
    if (!ref.mounted) {
      return;
    }

    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: true,
    );

    await controller.setMapAttributeBool(attributeParkingOn, value: true);
    await controller.setMapAttributeBool(attributeParkingFilteredPaidOn, value: parkingFilter.paidOn());
    await controller.setMapAttributeBool(attributeParkingFilteredFreeOn, value: parkingFilter.freeOn());
  }

  Future<void> hideParking() async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (!ref.mounted) {
      return;
    }
    final prefs = ref.read(sharedPrefsProvider);
    final attribute = prefs.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;
    final activeLayersNotifier = ref.read(activeLayerProvider.notifier);

    await activeLayersNotifier.removeActiveLayer();
    if (!ref.mounted) {
      return;
    }
    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: false,
    );

    await controller.setMapAttributeBool(attributeParkingOn, value: false);
  }
}
