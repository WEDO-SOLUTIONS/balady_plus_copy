import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wrc_debug.g.dart';

/// Global debug override flag for WRC
/// This allows static methods to work with debug override
bool _wrcDebugOverride = false;
bool get wrcDebugOverride => _wrcDebugOverride;

/// Debug provider to override WRC status
/// This allows developers to force the WRC feature to be active
/// regardless of the actual date
@riverpod
class WRCDebug extends _$WRCDebug {
  @override
  bool build() => _wrcDebugOverride;

  /// Toggle the debug override
  void toggle() {
    state = !state;
    _wrcDebugOverride = state;
  }

  /// Enable the debug override
  void enable() {
    state = true;
    _wrcDebugOverride = true;
  }

  /// Disable the debug override
  void disable() {
    state = false;
    _wrcDebugOverride = false;
  }
}
