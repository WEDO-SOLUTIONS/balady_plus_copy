import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_auto_enable_parking.g.dart';

const String _autoEnableParkingKey = 'navigator_settings.auto_enable_parking';

@riverpod
class _NavigatorAutoEnableParking extends _$NavigatorAutoEnableParking {
  @override
  bool? build() {
    ref.onDispose(() {
      final layers = ref.read(layersControlsProvider);

      if (layers.selectedType == LayerType.parkingLots) {
        ref.read(layersControlsProvider.notifier).hideParking();
      }
    });

    final sharedPrefs = ref.read(sharedPrefsProvider);
    final autoEnableParking = sharedPrefs.getBool(_autoEnableParkingKey);

    if (autoEnableParking == true) {
      ref.read(layersControlsProvider.notifier).enableParking();
    }

    return autoEnableParking;
  }

  void refresh() {
    ref.invalidateSelf();
  }

  void toggleAutoEnableParking({required bool value}) {
    state = value;

    ref.read(sharedPrefsProvider).setBool(_autoEnableParkingKey, value);

    if (value) {
      ref.read(layersControlsProvider.notifier).enableParking();
    } else {
      ref.read(layersControlsProvider.notifier).hideParking();
    }
  }
}

final navigatorAutoEnableParkingProvider = _navigatorAutoEnableParkingProvider;
