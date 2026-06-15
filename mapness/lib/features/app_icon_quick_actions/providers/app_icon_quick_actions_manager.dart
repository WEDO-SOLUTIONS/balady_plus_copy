import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_config.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_actions_platform.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_actions_manager.g.dart';

/// Publishes the BRD v0.2 static shortcut list with localized labels (BR#08).
@Riverpod(keepAlive: true)
class AppIconQuickActionsManager extends _$AppIconQuickActionsManager {
  final AppIconQuickActionsPlatformService _platformService = const AppIconQuickActionsPlatformService(appQuickActions);

  @override
  Future<void> build() async {
    ref.listen(appLanguageProvider, (_, __) async {
      await syncPublishedShortcuts();
    });

    await syncPublishedShortcuts();
  }

  /// Re-publishes static shortcuts — e.g. after language change (BR#08).
  Future<void> syncPublishedShortcuts() async {
    final config = ref.read(appIconQuickActionsConfigProvider);
    final language = ref.read(appLanguageProvider);
    final platform = await resolveCurrentAppIconQuickActionPlatform();
    await _platformService.syncShortcuts(
      config: config,
      language: language,
      platform: platform,
    );
  }
}
