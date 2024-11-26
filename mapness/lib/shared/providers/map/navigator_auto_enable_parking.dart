import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_auto_enable_parking.g.dart';

const String _autoEnableParkingKey = 'navigator_settings.auto_enable_parking';

@riverpod
class _NavigatorAutoEnableParking extends _$NavigatorAutoEnableParking {
  @override
  bool? build() {
    ref.onDispose(() {
      ref.read(layersControlsProvider.notifier).toggleParking();
    });

    final sharedPrefs = ref.read(sharedPrefsProvider);
    final autoEnableParking = sharedPrefs.getBool(_autoEnableParkingKey);

    if (autoEnableParking == true) {
      ref.read(layersControlsProvider.notifier).enableParking();
    }

    return autoEnableParking;
  }

  void toggleAutoEnableParking({required bool value}) {
    state = value;

    ref.read(sharedPrefsProvider)
      ..setBool(MapnessConstants.parkingEnabledFreeRoam, true)
      ..setBool(_autoEnableParkingKey, state ?? false);

    ref.read(layersControlsProvider.notifier).toggleParking();
  }
}

final navigatorAutoEnableParkingProvider = _navigatorAutoEnableParkingProvider;
