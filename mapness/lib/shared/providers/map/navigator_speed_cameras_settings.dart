import 'package:dgis_map/dgis_map_controller.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_speed_cameras_settings.g.dart';

const _prefsKey = 'navigator_settings.speed_cameras';

@Riverpod(keepAlive: true)
class _NavigatorSpeedCamerasSettings extends _$NavigatorSpeedCamerasSettings {
  DgisMapController? _dgisController;

  @override
  bool build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final camerasOn = sharedPrefs.getBool(_prefsKey) ?? true;

    _initDgisController(camerasOn);

    return camerasOn;
  }

  Future<void> _initDgisController(bool camerasOn) async {
    _dgisController = await ref.read(dgisControllerProvider.future);
    await _dgisController?.setMapAttributeBool(MapnessConstants.camerasOn, value: camerasOn);
  }

  Future<void> toggle() async {
    state = !state;
    await ref.read(sharedPrefsProvider).setBool(_prefsKey, state);
    await _dgisController?.setMapAttributeBool(MapnessConstants.camerasOn, value: state);
  }
}

final navigatorSpeedCamerasSettingsProvider = _navigatorSpeedCamerasSettingsProvider;
