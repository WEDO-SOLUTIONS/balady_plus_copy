import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_defaults.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_config.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_actions_platform.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_actions_manager.g.dart';

@Riverpod(keepAlive: true)
class AppIconQuickActionsManager extends _$AppIconQuickActionsManager {
  final AppIconQuickActionsPlatformService _platformService = const AppIconQuickActionsPlatformService(appQuickActions);

  @override
  Future<void> build() async {
    final language = ref.read(appLanguageProvider);
    final platform = await resolveCurrentAppIconQuickActionPlatform();

    // Publish BRD defaults immediately so shortcuts appear before remote config loads.
    await _platformService.syncShortcuts(
      config: AppIconQuickActionsDefaults.config,
      language: language,
      platform: platform,
    );

    ref.listen(appLanguageProvider, (_, __) async {
      await _syncFromConfig();
    });

    await _syncFromConfig();
  }

  Future<void> _syncFromConfig() async {
    final config = await ref.read(appIconQuickActionsConfigProvider.future);
    final language = ref.read(appLanguageProvider);
    final platform = await resolveCurrentAppIconQuickActionPlatform();
    await _platformService.syncShortcuts(
      config: config,
      language: language,
      platform: platform,
    );
  }

  Future<void> refresh() async {
    ref.invalidate(appIconQuickActionsConfigProvider);
    await _syncFromConfig();
  }
}
