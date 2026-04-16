import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_start.g.dart';

const String _prefsKey = 'isFirstStart';

/// Tracks if the app is started the first time
@Riverpod(keepAlive: true)
class FirstStart extends _$FirstStart {
  // cache the first received value for all consumers to get the same value
  bool? _isFirstRun;

  @override
  bool build() {
    final isFirstRun = _isFirstRun;
    if (isFirstRun != null) {
      return isFirstRun;
    }

    final sharedPrefs = ref.read(sharedPrefsProvider);
    final prefsIsFirstRun = sharedPrefs.getBool(_prefsKey) ?? true;
    _isFirstRun = prefsIsFirstRun;
    if (prefsIsFirstRun) {
      sharedPrefs.setBool(_prefsKey, false);
    }

    return prefsIsFirstRun;
  }
}
