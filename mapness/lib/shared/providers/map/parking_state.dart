import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/lifestyle_layers/providers/parking_details.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_state.g.dart';

const parkingTypeKey = 'parking_type_key';
const String attributeParkingOn = 'parkingOn';
const String attributeParkingFilteredPaidOn = 'parking_filter_paid_on';
const String attributeParkingFilteredFreeOn = 'parking_filter_free_on';

@Riverpod(keepAlive: true)
class ParkingState extends _$ParkingState {
  DgisMapController? _dgisController;

  @override
  ParkingStateEvent build() {
    final autoEnableParking = ref.read(navigatorAutoEnableParkingProvider);
    _initListeners();

    return ParkingStateEvent(
      filter: ParkingFilter.all,
      visible: autoEnableParking ?? false,
    );
  }

  Future<void> _initListeners() async {
    _dgisController = await ref.read(dgisControllerProvider.future);

    await _dgisController?.setMapAttributeBool(attributeParkingOn, value: false);

    ref.onDispose(
      () {
        _dgisController?.setMapAttributeBool(attributeParkingOn, value: false);
      },
    );
  }

  Future<void> showParking() async {
    final prefs = ref.read(sharedPrefsProvider);
    final attribute = prefs.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;
    final activeLayersNotifier = ref.read(activeLayerProvider.notifier);

    await activeLayersNotifier.setActiveLayer(LayerType.parkingLots);

    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: true,
    );

    await _dgisController?.setMapAttributeBool(attributeParkingOn, value: true);
    await _dgisController?.setMapAttributeBool(attributeParkingFilteredPaidOn, value: parkingFilter.paidOn());
    await _dgisController?.setMapAttributeBool(attributeParkingFilteredFreeOn, value: parkingFilter.freeOn());
  }

  Future<void> hideParking() async {
    final prefs = ref.read(sharedPrefsProvider);
    final attribute = prefs.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;
    final activeLayersNotifier = ref.read(activeLayerProvider.notifier);

    await activeLayersNotifier.removeActiveLayer();
    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: false,
    );

    await _dgisController?.setMapAttributeBool(attributeParkingOn, value: false);
  }
}
