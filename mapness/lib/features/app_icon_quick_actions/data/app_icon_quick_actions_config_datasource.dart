import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_urls.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_defaults.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppIconQuickActionsConfigDatasource {
  AppIconQuickActionsConfigDatasource({
    required this.dio,
    required this.environment,
  });

  final Dio dio;
  final EnvironmentConfig environment;

  static const _cacheFileName = 'app_icon_quick_actions_cache.json';

  String? _cacheFilePath;

  Future<AppIconQuickActionsConfig> getConfig() async {
    Metrics.logEventAdvanced(
      MetricsConstants.appIconQuickActionsKeys.configFetchStarted,
      group: MetricsConstants.appIconQuickActionsTag,
    );

    try {
      final remoteUrl = AppIconQuickActionsConfigUrls.getConfigUrl(environment);
      final response = await dio.get<dynamic>(
        remoteUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data as String) as Map<String, dynamic>;
        } else {
          json = response.data as Map<String, dynamic>;
        }
        final config = AppIconQuickActionsConfig.fromJson(json);
        if (AppIconQuickActionsDefaults.isValid(config)) {
          await _saveToCache(jsonEncode(json));
          Metrics.logEventAdvanced(
            MetricsConstants.appIconQuickActionsKeys.configFetchSuccess,
            group: MetricsConstants.appIconQuickActionsTag,
            props: {'version': config.version, 'source': 'remote'},
          );
          return config;
        }
        logger.log(
          'AppIconQuickActions: remote config empty/invalid, using cache/assets',
          logLevel: MapnessLogLevel.warning,
        );
      }
    } on DioException catch (e) {
      Metrics.logEventAdvanced(
        MetricsConstants.appIconQuickActionsKeys.configFetchFailed,
        group: MetricsConstants.appIconQuickActionsTag,
        props: {'source': 'remote', 'error': e.type.name},
      );
      logger.log(
        'AppIconQuickActions: remote fetch failed, using cache/assets: $e',
        logLevel: MapnessLogLevel.warning,
      );
    } catch (e, st) {
      Metrics.logEventAdvanced(
        MetricsConstants.appIconQuickActionsKeys.configFetchFailed,
        group: MetricsConstants.appIconQuickActionsTag,
        props: {'source': 'remote', 'error': e.toString()},
      );
      logger.log(
        'AppIconQuickActions: unexpected remote error: $e\n$st',
        logLevel: MapnessLogLevel.warning,
      );
    }

    return _loadFromCacheOrAssets();
  }

  Future<AppIconQuickActionsConfig> _loadFromCacheOrAssets() async {
    try {
      final path = await _getCacheFilePath();
      final file = File(path);
      if (await file.exists()) {
        final jsonOutput = await file.readAsString();
        final json = jsonDecode(jsonOutput) as Map<String, dynamic>;
        final config = AppIconQuickActionsConfig.fromJson(json);
        if (AppIconQuickActionsDefaults.isValid(config)) {
          Metrics.logEventAdvanced(
            MetricsConstants.appIconQuickActionsKeys.configCacheUsed,
            group: MetricsConstants.appIconQuickActionsTag,
            props: {'version': config.version},
          );
          return config;
        }
      }
    } catch (e) {
      logger.log(
        'AppIconQuickActions: cache read failed, using bundled assets: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }

    return _loadFromAssets();
  }

  Future<AppIconQuickActionsConfig> _loadFromAssets() async {
    for (final assetPath in AppIconQuickActionsDefaults.bundledAssetPaths) {
      try {
        final jsonOutput = await rootBundle.loadString(assetPath);
        final json = jsonDecode(jsonOutput) as Map<String, dynamic>;
        final config = AppIconQuickActionsConfig.fromJson(json);
        if (AppIconQuickActionsDefaults.isValid(config)) {
          Metrics.logEventAdvanced(
            MetricsConstants.appIconQuickActionsKeys.configAssetFallback,
            group: MetricsConstants.appIconQuickActionsTag,
            props: {'version': config.version, 'asset': assetPath},
          );
          return config;
        }
      } catch (e) {
        logger.log(
          'AppIconQuickActions: failed to load $assetPath: $e',
          logLevel: MapnessLogLevel.warning,
        );
      }
    }

    Metrics.logEventAdvanced(
      MetricsConstants.appIconQuickActionsKeys.configAssetFallback,
      group: MetricsConstants.appIconQuickActionsTag,
      props: {'version': AppIconQuickActionsDefaults.config.version, 'asset': 'hardcoded'},
    );
    return AppIconQuickActionsDefaults.config;
  }

  Future<String> _getCacheFilePath() async {
    if (_cacheFilePath != null) {
      return _cacheFilePath!;
    }
    final directory = await getApplicationDocumentsDirectory();
    _cacheFilePath = '${directory.path}/$_cacheFileName';
    return _cacheFilePath!;
  }

  Future<void> _saveToCache(String jsonOutput) async {
    try {
      final path = await _getCacheFilePath();
      await File(path).writeAsString(jsonOutput);
    } catch (e) {
      logger.log(
        'AppIconQuickActions: failed to save cache: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
  }
}

Future<AppIconQuickActionPlatform> resolveCurrentAppIconQuickActionPlatform() async {
  if (Platform.isIOS) {
    return AppIconQuickActionPlatform.ios;
  }
  if (await CommonFunctions.isHuaweiDevice()) {
    return AppIconQuickActionPlatform.huawei;
  }
  return AppIconQuickActionPlatform.android;
}

/// BR#02 – respect OS shortcut limits (iOS max 4; Android/Huawei typically 4).
int maxPublishedShortcutsForPlatform(AppIconQuickActionPlatform platform) => switch (platform) {
  AppIconQuickActionPlatform.ios => 4,
  AppIconQuickActionPlatform.android => 4,
  AppIconQuickActionPlatform.huawei => 4,
};

List<AppIconQuickActionItem> activeShortcutsForPlatform(
  AppIconQuickActionsConfig config,
  AppIconQuickActionPlatform platform,
) {
  final sorted = config.shortcuts.where((item) => item.status.isActive && item.supportsPlatform(platform)).toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  return sorted.take(maxPublishedShortcutsForPlatform(platform)).toList();
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
    '/snapSend',
    '/quickFeedback',
    '/freeRoam',
    '/qibla',
    '/athkar',
    '/quran',
    '/parking',
    '/miniApps',
    '/stories',
  };

  return supportedPaths.contains(path) || path.startsWith('/app');
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
