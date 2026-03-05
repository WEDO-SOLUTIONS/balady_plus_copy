import 'dart:async';

import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_national_day.g.dart';

/// Configuration for the Saudi National Day date range
class SaudiNationalDayConfig {
  /// Start date for Saudi National Day (September 23rd)
  static DateTime get startDate => DateTime(2025, 9, 18);

  /// End date for Saudi National Day (September 23rd)
  static DateTime get endDate => DateTime(2025, 9, 27, 23, 59, 59);

  /// Update interval for the provider (15 minutes)
  static const Duration updateInterval = Duration(minutes: 15);
}

/// Provider that checks if the current time is between two specified dates
/// and updates every 15 minutes.
///
/// Returns `true` if the current time is between the start and end dates,
/// `false` otherwise.
@riverpod
class SaudiNationalDay extends _$SaudiNationalDay {
  Timer? _timer;

  @override
  bool build() {
    // Check if debug override is enabled
    final debugOverride = ref.watch(saudiNationalDayDebugProvider);
    if (debugOverride) {
      return true;
    }

    // Start the periodic timer to update the state every 15 minutes
    _startPeriodicUpdate();

    // Set up cleanup when the provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });

    // Return the initial state
    return _isCurrentTimeInRange();
  }

  /// Starts a periodic timer that updates the state every 15 minutes
  void _startPeriodicUpdate() {
    _timer?.cancel();

    final now = DateTime.now();

    // If the current time is more than 2 hours before the start or after end date, don't start the timer
    final isBeforeStart = now.isBefore(SaudiNationalDayConfig.startDate.subtract(const Duration(hours: 2)));
    final isAfterEnd = now.isAfter(SaudiNationalDayConfig.endDate.add(const Duration(hours: 2)));
    if (isBeforeStart || isAfterEnd) {
      return;
    }

    _timer = Timer.periodic(
      SaudiNationalDayConfig.updateInterval,
      (_) {
        // Update the state with the current check result
        state = _isCurrentTimeInRange();
      },
    );
  }

  /// Checks if the current time is within the specified date range
  bool _isCurrentTimeInRange() {
    final now = DateTime.now();
    return now.isAfter(SaudiNationalDayConfig.startDate) && now.isBefore(SaudiNationalDayConfig.endDate);
  }

  /// Manually triggers an update of the state
  void refresh() {
    state = _isCurrentTimeInRange();
  }

  /// Stops the periodic timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Restarts the periodic timer
  void restartTimer() {
    _startPeriodicUpdate();
  }

  /// Simple provider that returns the current status without periodic updates
  /// Use this if you only need a one-time check
  static bool isNow() {
    // Check if debug override is enabled
    if (saudiNationalDayDebugOverride) {
      return true;
    }

    final now = DateTime.now();
    return now.isAfter(SaudiNationalDayConfig.startDate) && now.isBefore(SaudiNationalDayConfig.endDate);
  }

  /// Provider that returns the remaining time until Saudi National Day
  /// Returns null if the date has passed or is not this year
  static Duration? countdown() {
    final now = DateTime.now();
    return countdownFromDate(now);
  }

  static Duration? countdownFromDate(DateTime now) {
    // If debug override is enabled, return null (no countdown needed)
    if (saudiNationalDayDebugOverride) {
      return null;
    }

    // If we're past the current year's date, return null
    if (now.isAfter(SaudiNationalDayConfig.startDate)) {
      return null;
    }

    return SaudiNationalDayConfig.startDate.difference(now);
  }
}
