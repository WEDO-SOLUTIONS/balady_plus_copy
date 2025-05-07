import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_auto_enable_parking.g.dart';

@riverpod
class _NavigatorAutoEnableParking extends _$NavigatorAutoEnableParking {
  @override
  bool? build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final autoEnableParking = sharedPrefs.getBool(MapnessConstants.parkingEnabledFreeRoam);

    return autoEnableParking;
  }

  void refresh() {
    ref.invalidateSelf();
  }

  void toggleAutoEnableParking({required bool value}) {
    state = value;

    ref.read(sharedPrefsProvider).setBool(MapnessConstants.parkingEnabledFreeRoam, value);

    if (value) {
      ref.read(layersControlsProvider.notifier).enableParking();
    } else {
      ref.read(layersControlsProvider.notifier).hideParking();
    }
  }
}

final navigatorAutoEnableParkingProvider = _navigatorAutoEnableParkingProvider;
