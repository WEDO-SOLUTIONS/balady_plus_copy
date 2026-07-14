import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_features.g.dart';

class AppFeatures {
  AppFeatures({
    required this.naviEnabled,
  });
  final bool naviEnabled;
}

const _prefsKey = 'settings.features';

@Riverpod(keepAlive: true)
class _AppFeatures extends _$AppFeatures {
  @override
  AppFeatures build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    return AppFeatures(
      // by default navi is enabled
      naviEnabled: sharedPrefs.getBool('$_prefsKey.navi') ?? true,
    );
  }

  void enableNavi() {
    mixpanel?.registerSuperPropertiesOnce({'AppFeatures': 'navi'});
    BaladyAnalytics.instance.setSessionProperty('AppFeatures', 'navi');
    ref.read(sharedPrefsProvider).setBool('$_prefsKey.navi', true);
    ref.invalidateSelf();
  }
}

final appFeaturesProvider = _appFeaturesProvider;
