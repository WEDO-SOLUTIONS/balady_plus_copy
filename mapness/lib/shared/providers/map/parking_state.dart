import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/lifestyle_layers/providers/parking_details.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_state.g.dart';

const parkingTypeKey = 'parking_type_key';

@Riverpod(keepAlive: true)
class ParkingState extends _$ParkingState {
  DgisMapController? _dgisController;

  @override
  ParkingStateEvent build() {
    _initListeners();

    return const ParkingStateEvent(
      filter: ParkingFilter.all,
      visible: true,
    );
  }

  Future<void> _initListeners() async {
    _dgisController = await ref.read(dgisControllerProvider.future);

    ref.onDispose(
      () {
        _dgisController?.setMapAttributeBool('parkingOn', false);
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

    await _dgisController?.setMapAttributeBool('parkingOn', true);
    await _dgisController?.setMapAttributeBool('parking_filter_paid_on', parkingFilter.paidOn());
    await _dgisController?.setMapAttributeBool('parking_filter_free_on', parkingFilter.freeOn());
  }

  Future<void> hideParking() async {
    final read = ref.read(sharedPrefsProvider);
    final attribute = read.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;

    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: false,
    );

    await _dgisController?.setMapAttributeBool('parkingOn', false);
  }
}
