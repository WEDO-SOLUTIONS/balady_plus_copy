import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/lifestyle_layers/providers/parking_details.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
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
    _initListeners();

    return const ParkingStateEvent(
      filter: ParkingFilter.all,
      visible: false,
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
    final read = ref.read(sharedPrefsProvider);
    final attribute = read.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;

    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: true,
    );

    await _dgisController?.setMapAttributeBool(attributeParkingOn, value: true);
    await _dgisController?.setMapAttributeBool(attributeParkingFilteredPaidOn, value: parkingFilter.paidOn());
    await _dgisController?.setMapAttributeBool(attributeParkingFilteredFreeOn, value: parkingFilter.freeOn());
  }

  Future<void> hideParking() async {
    final read = ref.read(sharedPrefsProvider);
    final attribute = read.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;

    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: false,
    );

    await _dgisController?.setMapAttributeBool(attributeParkingOn, value: false);
  }
}
