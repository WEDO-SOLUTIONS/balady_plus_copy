import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cityscape_debug.g.dart';

/// Global debug override flag for Cityscape Global
/// This allows static methods to work with debug override
bool _cityscapeDebugOverride = true;
bool get cityscapeDebugOverride => _cityscapeDebugOverride;

/// Debug provider to override Cityscape Global status
/// This allows developers to force the Cityscape Global feature to be active
/// regardless of the actual date
@riverpod
class CityscapeDebug extends _$CityscapeDebug {
  @override
  bool build() => _cityscapeDebugOverride;

  /// Toggle the debug override
  void toggle() {
    state = !state;
    _cityscapeDebugOverride = state;
  }

  /// Enable the debug override
  void enable() {
    state = true;
    _cityscapeDebugOverride = true;
  }

  /// Disable the debug override
  void disable() {
    state = false;
    _cityscapeDebugOverride = false;
  }
}
