import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_state.g.dart';

const parkingTypeKey = 'parking_type_key';

@Riverpod(keepAlive: true)
class ParkingState extends _$ParkingState {
  StreamSubscription<ParkingStateEvent>? _parkingSubscription;
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

    await _dgisController?.naviTrafficParkingController.onAttached();
    _parkingSubscription =
        _dgisController?.naviTrafficParkingController.parkingStateEvents.listen((event) => state = event);

    ref.onDispose(
      () {
        _parkingSubscription?.cancel();
        _dgisController?.naviTrafficParkingController.onDetached();
      },
    );
  }

  Future<void> onParkingTap() async {
    final read = ref.read(sharedPrefsProvider);
    final attribute = read.getString(parkingTypeKey);
    final parkingFilter = attribute != null ? ParkingFilter.fromAttribute(attribute) : ParkingFilter.all;
    await _dgisController?.naviTrafficParkingController.setParkingFilter(parkingFilter);

    state = ParkingStateEvent(
      filter: parkingFilter,
      visible: true,
    );

    await _dgisController?.naviTrafficParkingController.onParkingClicked();
  }
}
