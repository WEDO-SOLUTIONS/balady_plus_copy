import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_national_day_debug.g.dart';

/// Global debug override flag for Saudi National Day
/// This allows static methods to work with debug override
bool _saudiNationalDayDebugOverride = false;
bool get saudiNationalDayDebugOverride => _saudiNationalDayDebugOverride;

/// Debug provider to override Saudi National Day status
/// This allows developers to force the Saudi National Day feature to be active
/// regardless of the actual date
@riverpod
class SaudiNationalDayDebug extends _$SaudiNationalDayDebug {
  @override
  bool build() => false;

  /// Toggle the debug override
  void toggle() {
    state = !state;
    _saudiNationalDayDebugOverride = state;
  }

  /// Enable the debug override
  void enable() {
    state = true;
    _saudiNationalDayDebugOverride = true;
  }

  /// Disable the debug override
  void disable() {
    state = false;
    _saudiNationalDayDebugOverride = false;
  }
}
