import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_auto_enable_parking.g.dart';

const String _autoEnableParkingKey = 'navigator_settings.auto_enable_parking';

@riverpod
class _NavigatorAutoEnableParking extends _$NavigatorAutoEnableParking {
  @override
  bool? build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final autoEnableParking = sharedPrefs.getBool(_autoEnableParkingKey);

    return autoEnableParking;
  }

  void toggleAutoEnableParking({required bool value}) {
    state = value;
    ref.read(sharedPrefsProvider).setBool(_autoEnableParkingKey, state ?? false);
  }
}

final navigatorAutoEnableParkingProvider = _navigatorAutoEnableParkingProvider;
