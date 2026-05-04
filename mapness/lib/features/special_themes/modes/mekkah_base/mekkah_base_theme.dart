import 'dart:async';

import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mekkah_base_theme.g.dart';

/// Returns true when the user is considered to be "in Makkah" for theming purposes.
///
/// This is a location-based toggle that powers the Makkah base and seasonal themes.
/// Uses coordinates and radius from remote config (places_activation.json).
///
/// Includes throttling to prevent rapid theme changes when user crosses the
/// Makkah area border repeatedly (e.g., due to GPS jitter).
@Riverpod(keepAlive: true)
class MekkahBaseTheme extends _$MekkahBaseTheme {
  static const _throttleDuration = Duration(seconds: 10);

  Timer? _throttleTimer;
  bool _isThrottled = false;
  bool? _lastValue;

  @override
  bool build() {
    ref.onDispose(() {
      _throttleTimer?.cancel();
    });

    final location = ref.watch(locationProvider);
    if (location == null) {
      // Don't reset _lastValue when location is temporarily null
      // This prevents theme flickering during navigation or provider rebuilds
      // Return the previous value if we had one, otherwise false
      return _lastValue ?? false;
    }

    final mekkahConfig = ref.watch(placesActivationMekkahProvider);
    final area = mekkahConfig.area ?? MakkahAreaConfig.defaultConfig;

    final distanceKm = CommonFunctions.distance(
      location.latitude,
      location.longitude,
      area.latitude,
      area.longitude,
    );
    final isInMakkah = distanceKm <= area.radiusKm;

    logger.log(
      '[MekkahBaseTheme] location=(${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}) '
      'distance=${distanceKm.toStringAsFixed(2)}km isInMakkah=$isInMakkah '
      'lastValue=$_lastValue isThrottled=$_isThrottled',
    );

    // On first build, initialize and return
    if (_lastValue == null) {
      _lastValue = isInMakkah;
      return isInMakkah;
    }

    // If value hasn't changed, return current value
    if (_lastValue == isInMakkah) {
      return _lastValue!;
    }

    // Value changed - check if we should apply throttling
    if (_isThrottled) {
      logger.log('[MekkahBaseTheme] THROTTLED - ignoring change from $_lastValue to $isInMakkah');
      return _lastValue!;
    }

    // Value changed and not throttled - start throttle and return new value
    logger.log('[MekkahBaseTheme] Changing theme from $_lastValue to $isInMakkah');
    _startThrottle();
    _lastValue = isInMakkah;
    return isInMakkah;
  }

  void _startThrottle() {
    _isThrottled = true;
    _throttleTimer?.cancel();
    _throttleTimer = Timer(_throttleDuration, () {
      _isThrottled = false;
      ref.invalidateSelf();
    });
  }
}
