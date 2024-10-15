import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entities/path_nav/models/navigation_parameters.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_route_settings.g.dart';

const String _avoidTollRoadsKey = 'navigator_settings.avoid_toll_roads';
const String _avoidUnpavedRoadsKey = 'navigator_settings.avoid_unpaved_roads';

@riverpod
class _NavigatorRouteSettings extends _$NavigatorRouteSettings {
  @override
  NavigationParameters build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final avoidTollRoads = sharedPrefs.getBool(_avoidTollRoadsKey) ?? false;
    final avoidUnpavedRoads = sharedPrefs.getBool(_avoidUnpavedRoadsKey) ?? false;

    return NavigationParameters(
      avoidTollRoads: avoidTollRoads,
      avoidUnpavedRoads: avoidUnpavedRoads,
    );
  }

  void toggleAvoidTollRoads() {
    state = state.copyWith(avoidTollRoads: !state.avoidTollRoads);
    ref.read(sharedPrefsProvider).setBool(_avoidTollRoadsKey, state.avoidTollRoads);
  }

  void toggleAvoidUnpavedRoads() {
    state = state.copyWith(avoidUnpavedRoads: !state.avoidUnpavedRoads);
    ref.read(sharedPrefsProvider).setBool(_avoidUnpavedRoadsKey, state.avoidUnpavedRoads);
  }
}

final navigatorRouteSettingsProvider = _navigatorRouteSettingsProvider;
