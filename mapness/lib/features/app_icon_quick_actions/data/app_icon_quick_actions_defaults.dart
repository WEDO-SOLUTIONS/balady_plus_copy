import 'package:collection/collection.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';

/// BRD v0.2 — static predefined quick actions (BR#01, BR#02).
/// Fixed list implemented in the mobile app; not fetched from a remote API.
class AppIconQuickActionsDefaults {
  AppIconQuickActionsDefaults._();

  static const bundledAssetPaths = [
    'packages/mapness/assets/quick_actions_config.json',
    'assets/quick_actions_config.json',
  ];

  /// Predefined shortcuts in BRD order (BR#03).
  static const config = AppIconQuickActionsConfig(
    version: 1,
    shortcuts: [
      AppIconQuickActionItem(
        key: 'favorites',
        labelEn: 'Favorites',
        labelAr: 'المفضلة',
        destination: 'https://plus.balady.gov.sa/#/favourites',
        status: AppIconQuickActionStatus.active,
        order: 1,
        platforms: AppIconQuickActionPlatform.values,
        requireLogin: true,
        requirePermissions: [],
        iconReference: 'Bookmark',
      ),
      AppIconQuickActionItem(
        key: 'directions',
        labelEn: 'Directions',
        labelAr: 'التنقل',
        destination: 'https://plus.balady.gov.sa/#/directions',
        status: AppIconQuickActionStatus.active,
        order: 2,
        platforms: AppIconQuickActionPlatform.values,
        requireLogin: true,
        requirePermissions: [AppIconQuickActionPermission.location],
        iconReference: 'Route',
      ),
      AppIconQuickActionItem(
        key: 'search_for_place',
        labelEn: 'Search for Place',
        labelAr: 'البحث عن مكان',
        destination: 'https://plus.balady.gov.sa/#/search',
        status: AppIconQuickActionStatus.active,
        order: 3,
        platforms: AppIconQuickActionPlatform.values,
        requireLogin: false,
        requirePermissions: [],
        iconReference: 'Search',
      ),
      AppIconQuickActionItem(
        key: 'share_my_location',
        labelEn: 'Share My Location',
        labelAr: 'شارك موقعي الحالي',
        destination: 'https://plus.balady.gov.sa/#/shareMyLocation',
        status: AppIconQuickActionStatus.active,
        order: 4,
        platforms: AppIconQuickActionPlatform.values,
        requireLogin: true,
        requirePermissions: [AppIconQuickActionPermission.location],
        iconReference: 'MyLocation',
      ),
      AppIconQuickActionItem(
        key: 'share_live_location',
        labelEn: 'Share Live Location',
        labelAr: 'شارك تتبع لموقعي',
        destination: 'https://plus.balady.gov.sa/#/shareLiveLocation',
        status: AppIconQuickActionStatus.active,
        order: 5,
        platforms: AppIconQuickActionPlatform.values,
        requireLogin: true,
        requirePermissions: [AppIconQuickActionPermission.location],
        iconReference: 'FollowOn',
      ),
      AppIconQuickActionItem(
        key: 'contribute',
        labelEn: 'Contribute',
        labelAr: 'ساهم معنا',
        destination: 'https://plus.balady.gov.sa/#/contribute',
        status: AppIconQuickActionStatus.active,
        order: 6,
        platforms: AppIconQuickActionPlatform.values,
        requireLogin: false,
        requirePermissions: [],
        iconReference: 'Home',
      ),
    ],
  );

  static AppIconQuickActionItem? findShortcut(String key) =>
      config.shortcuts.where((shortcut) => shortcut.key == key).firstOrNull;

  static bool isValid(AppIconQuickActionsConfig value) => value.shortcuts.isNotEmpty;
}
