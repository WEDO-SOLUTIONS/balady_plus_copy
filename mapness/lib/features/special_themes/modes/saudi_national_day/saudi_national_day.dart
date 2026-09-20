import 'dart:async';

import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_config.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_debug.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_resolved_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_national_day.g.dart';

/// How often the provider re-checks whether the activation window is open.
///
/// The window is only a few days long, so a coarse tick is enough to flip the
/// theme within the same session without burning wakeups.
const Duration kSaudiNationalDayUpdateInterval = Duration(minutes: 15);

/// Whether the Saudi National Day theme is currently active.
///
/// Dates, the master switch and the banner copy all come from remote config
/// — see [saudiNationalDayResolvedConfigProvider] for the Firebase → OCI →
/// bundled-default priority chain. Nothing here is hard-coded to a year, so
/// moving the window is a Console edit rather than a release.
@riverpod
class SaudiNationalDay extends _$SaudiNationalDay {
  Timer? _timer;

  @override
  bool build() {
    // Debug override short-circuits everything, including the timer.
    if (ref.watch(saudiNationalDayDebugProvider)) {
      return true;
    }

    final config = ref.watch(saudiNationalDayResolvedConfigProvider);

    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });

    _startPeriodicUpdate(config);

    return config.isActiveAt(DateTime.now());
  }

  /// Starts the recheck timer, but only around the activation window.
  ///
  /// Outside a 2-hour margin there is nothing to observe, so the timer is
  /// skipped entirely rather than ticking all year.
  void _startPeriodicUpdate(SaudiNationalDayRemoteConfig config) {
    _timer?.cancel();
    _timer = null;

    if (!config.enabled) {
      return;
    }

    final now = DateTime.now();
    final isBeforeStart = now.isBefore(config.startDate.subtract(const Duration(hours: 2)));
    final isAfterEnd = now.isAfter(config.endDate.add(const Duration(hours: 2)));
    if (isBeforeStart || isAfterEnd) {
      return;
    }

    _timer = Timer.periodic(kSaudiNationalDayUpdateInterval, (_) {
      final latest = ref.read(saudiNationalDayResolvedConfigProvider);
      state = latest.isActiveAt(DateTime.now());
    });
  }

  /// Manually re-evaluates the activation window.
  void refresh() {
    final config = ref.read(saudiNationalDayResolvedConfigProvider);
    state = config.isActiveAt(DateTime.now());
  }

  /// Synchronous check for widget `build()` methods that only need a colour
  /// or icon variant and have no [Ref] to hand.
  ///
  /// Prefer watching this provider where a [WidgetRef] is available, so the
  /// widget rebuilds when the window opens or closes. This reads the config
  /// last published by [saudiNationalDayResolvedConfigProvider].
  static bool isNow() {
    if (saudiNationalDayDebugOverride) {
      return true;
    }
    return SaudiNationalDayRemoteConfig.isNowActive();
  }
}

/// Time remaining until the activation window opens, or `null` once it has
/// started (or when the theme is disabled entirely).
@riverpod
Duration? saudiNationalDayCountdown(Ref ref) {
  if (ref.watch(saudiNationalDayDebugProvider)) {
    return null;
  }

  final config = ref.watch(saudiNationalDayResolvedConfigProvider);
  if (!config.enabled) {
    return null;
  }

  final now = DateTime.now();
  if (!now.isBefore(config.startDate)) {
    return null;
  }

  return config.startDate.difference(now);
}
