import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'founding_day_debug.g.dart';

/// Global debug override flag for WRC
/// This allows static methods to work with debug override
bool _foundingDayDebugOverride = false;
bool get foundingDayDebugOverride => _foundingDayDebugOverride;

/// Debug provider to override Founding Day status
/// This allows developers to force the Founding Day feature to be active
/// regardless of the actual date
@riverpod
class FoundingDayDebugUrbi extends _$FoundingDayDebugUrbi {
  @override
  bool build() => _foundingDayDebugOverride;

  /// Toggle the debug override
  void toggle() {
    state = !state;
    _foundingDayDebugOverride = state;
  }

  /// Enable the debug override
  void enable() {
    state = true;
    _foundingDayDebugOverride = true;
  }

  /// Disable the debug override
  void disable() {
    state = false;
    _foundingDayDebugOverride = false;
  }
}
