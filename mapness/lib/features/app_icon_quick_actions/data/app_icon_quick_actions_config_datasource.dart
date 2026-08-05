import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';

Future<AppIconQuickActionPlatform> resolveCurrentAppIconQuickActionPlatform() async {
  if (Platform.isIOS) {
    return AppIconQuickActionPlatform.ios;
  }
  if (await CommonFunctions.isHuaweiDevice()) {
    return AppIconQuickActionPlatform.huawei;
  }
  return AppIconQuickActionPlatform.android;
}

/// Typical home-screen icon limit per OS (BR#03). The app publishes the full BRD list;
/// the OS may display fewer shortcuts in predefined order.
int maxPublishedShortcutsForPlatform(AppIconQuickActionPlatform platform) => switch (platform) {
  AppIconQuickActionPlatform.ios => 4,
  AppIconQuickActionPlatform.android => 4,
  AppIconQuickActionPlatform.huawei => 4,
};

/// Active BRD shortcuts for the current platform, sorted by [AppIconQuickActionItem.order].
List<AppIconQuickActionItem> activeShortcutsForPlatform(
  AppIconQuickActionsConfig config,
  AppIconQuickActionPlatform platform,
) {
  return config.shortcuts.where((item) => item.status.isActive && item.supportsPlatform(platform)).toList()
    ..sort((a, b) => a.order.compareTo(b.order));
}

String resolveNativeQuickActionIcon(String iconReference) {
  if (iconReference.isEmpty) {
    return iconReference;
  }

  if (Platform.isIOS) {
    return iconReference;
  }

  const androidIconMap = <String, String>{
    'Bookmark': 'qa_bookmark',
    'Route': 'qa_route',
    'Search': 'qa_search',
    'MyLocation': 'qa_location',
    'FollowOn': 'qa_follow_on',
    'Home': 'qa_contribute',
  };

  return androidIconMap[iconReference] ?? iconReference.toLowerCase();
}

/// BRD v0.2 predefined destination paths only.
bool isSupportedQuickActionDestination(Uri uri) {
  final path = _destinationPath(uri);
  if (path.isEmpty) {
    return false;
  }

  const supportedPaths = {
    '/favourites',
    '/directions',
    '/search',
    '/shareMyLocation',
    '/shareLiveLocation',
    '/contribute',
  };

  return supportedPaths.contains(path);
}

String _destinationPath(Uri uri) {
  if (uri.fragment.isNotEmpty) {
    final fragmentUri = Uri.tryParse(uri.fragment);
    if (fragmentUri != null && fragmentUri.path.isNotEmpty) {
      return fragmentUri.path;
    }
  }
  return uri.path;
}
