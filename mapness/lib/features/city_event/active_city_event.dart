import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/cityscape/cityscape.dart';
import 'package:mapness/features/cityscape/cityscape_debug.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/founding_day/founding_day_debug.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day_debug.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_city_event.g.dart';

/// Provider that determines which city event is currently active
///
/// Returns the active event with highest priority (lowest priority number)
/// when multiple events have overlapping date ranges.
///
/// Priority order: WRC (1) > Saudi National Day (2) > Cityscape (3)
///
/// Debug overrides take precedence over actual date ranges.
///
/// TIFO ("game mode") pre-empts every city event: while its map layer is on,
/// no city event should be shown at the same time.
@riverpod
class ActiveCityEvent extends _$ActiveCityEvent {
  @override
  CityEventType? build() {
    if (ref.watch(tifoBuildingsMapLayerProvider)) {
      return null;
    }
    if (ref.watch(saudiNationalDayProvider)) {
      return CityEventType.saudiNationalDay;
    }
    if (ref.watch(cityscapeProvider)) {
      return CityEventType.cityscape;
    }
    if (ref.watch(foundingDayUrbiProvider)) {
      return CityEventType.foundingDay;
    }
    if (ref.watch(leapDebugProvider)) {
      return CityEventType.leap;
    }

    // Check actual date ranges from remote config
    final env = ref.watch(dgisEnvironmentProvider).value;
    if (env == null) {
      return null;
    }

    final activeEvents = <CityEventType>[];

    if (env.saudiNationalDayDateRange.isNow) {
      activeEvents.add(CityEventType.saudiNationalDay);
    }
    if (env.cityscapeDateTimeRange.isNow) {
      activeEvents.add(CityEventType.cityscape);
    }
    if (env.foundingDayDateRange.isNow) {
      activeEvents.add(CityEventType.foundingDay);
    }
    if (env.leapDateRange.isVisibleNow) {
      activeEvents.add(CityEventType.leap);
    }

    // Return event with highest priority (lowest number)
    if (activeEvents.isEmpty) {
      return null;
    }
    activeEvents.sort((a, b) => a.priority.compareTo(b.priority));

    return activeEvents.first;
  }
}
