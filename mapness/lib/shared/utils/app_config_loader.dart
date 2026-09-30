import 'dart:async';
import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/remote_config_constants.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Bundled default for `satellite_config` so the satellite layer works
/// out-of-the-box before Firebase Console is wired up. Firebase Remote
/// Config overrides this value at runtime — rotating the ESRI token is
/// just editing the JSON in the Console (no app release needed).
///
/// **Current default — Saudi Geoportal** (production endpoint). Token is
/// KSA-restricted, server caps expiry at ~30 days regardless of the
/// requested duration. Rotate via Firebase Console under the
/// `satellite_config` key.
///
/// Alternate (dev/staging when Geoportal is unreachable — e.g. behind
/// non-KSA network) — ESRI World Imagery, public, no token required.
/// Restricted by ESRI ToS to non-commercial use; do not ship to prod.
/// ```json
/// {
///   "layer_name": "satellite",
///   "url_template": "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
///   "token": "",
///   "expires": 0
/// }
/// ```
///
/// Schema: `layer_name`, `url_template`, `token`, `expires`. `{TOKEN}`
/// in the template is substituted at runtime; omit it for token-less
/// servers.
const String kSatelliteConfigBundledDefault =
    '{"layer_name":"satellite",'
    '"url_template":"https://www.geoportal.sa/basemap/rest/services/Imagery/BasemapImagery/MapServer/tile/{z}/{y}/{x}?token={TOKEN}",'
    // '"token":"qiCZf9ZHurs_jUeR2KSOrJNpujNC13mbFVNxzpPwmUpe5d7TqEV2Nl0I9VmVPD5OsHMVSHcvVqYHaVLm94FhiItxsGpAcz2flsjDNB7AITA.",'
    '"token":"qiCZf9ZHurs_jUeR2KSOrIk41Cwepa6yQkV5XY4CG-2MMKuA_S_CIwkZNy3M9AEa2CQomyYYZNTvALaKJdxEr5GX-8XnZjz1LbUvsKX3MNE.",'
    '"expires":1784245894893}';

class AppConfigLoader {
  AppConfigLoader._();

  static Completer<FirebaseRemoteConfig?>? _config;

  /// Network timeout of a single Remote Config fetch (Firebase's own default).
  static const _fetchTimeout = Duration(seconds: 60);

  /// How long start-up waits for the fetch when a config fetched on an earlier launch is already active.
  static const _startupFetchWait = Duration(seconds: 3);

  /// How long start-up waits for the fetch on the first launch: nothing is cached yet, and without the fetched
  /// vendor config the map SDK starts from the bundled asset.
  static const _firstLaunchFetchWait = Duration(seconds: 10);

  static Future<void> init(EnvType envType) async {
    if (_config != null) {
      await _config!.future;
      return;
    }

    _config = Completer();
    try {
      await Firebase.initializeApp();

      /// Get the instance of FirebaseRemoteConfig
      final remoteConfig = FirebaseRemoteConfig.instance;

      /// Set the config settings where fetchTimeout is the maximum time to wait,
      /// and minimumFetchInterval is the minimum time between fetch requests
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: _fetchTimeout,
          minimumFetchInterval: const Duration(minutes: 2),
        ),
      );

      /// In-code defaults used until the Firebase Console value is fetched.
      await remoteConfig.setDefaults({
        RemoteConfigConstants.satelliteConfig: kSatelliteConfigBundledDefault,
        // BALADY-3754: base-map switcher hidden until the satellite tile
        // source is production-ready.
        RemoteConfigConstants.baseMapSwitcherEnabled: false,
      });

      /// Ensure Remote Config is initialized: this activates the values fetched on an earlier launch.
      await remoteConfig.ensureInitialized();
      await _fetchAndActivateForStartup(remoteConfig, envType);

      remoteConfig.onConfigUpdated.listen(
        (event) async {
          await _saveAppConfig(remoteConfig, envType);
        },
      );
      _config!.complete(remoteConfig);
    } catch (e, st) {
      /// If an error occurs, reset the config and print the error to debug output
      logger.log(
        'Error initializing Firebase Remote Config: ${e.toString()} ${st.toString()}',
        logLevel: MapnessLogLevel.error,
      );
      _config!.complete();
    }

    await _saveAppConfig(await _config!.future, envType);
  }

  /// Fetches and activates the latest config, but does not hold the start-up (which waits for this before the first
  /// frame) on a slow network for longer than needed: once a config from an earlier launch is active, the app starts
  /// with it after [_startupFetchWait] and the fetch completes in the background, saving the fresh config for the next
  /// launch. On a normal network the fetch finishes well within the wait and nothing changes.
  static Future<void> _fetchAndActivateForStartup(FirebaseRemoteConfig remoteConfig, EnvType envType) async {
    // `lastFetchTime` comes from the native SDK and is 0 until the first successful fetch on this install.
    final hasFetchedBefore = remoteConfig.lastFetchTime.millisecondsSinceEpoch > 0;
    final fetch = remoteConfig.fetchAndActivate();
    try {
      await fetch.timeout(hasFetchedBefore ? _startupFetchWait : _firstLaunchFetchWait);
    } on TimeoutException {
      logger.log(
        'Remote Config fetch is slow; starting with ${hasFetchedBefore ? 'the previous' : 'the bundled'} config',
        logLevel: MapnessLogLevel.info,
      );
      unawaited(
        fetch
            .then((_) => _saveAppConfig(remoteConfig, envType))
            .catchError(
              (Object e, StackTrace st) => logger.log(
                'Background Remote Config fetch failed: $e $st',
                logLevel: MapnessLogLevel.error,
              ),
            ),
      );
    }
  }

  static Future<String> getAppConfig() async {
    if (_config?.isCompleted != true) {
      throw Exception('AppConfigLoader is not initialized');
    }
    final box = await Hive.openBox(MapnessConstants.envConfigBoxKey);
    return box.get(MapnessConstants.vendorConfigKey);
  }

  static Future<String?> getMarkerType() async {
    final config = await _config?.future;
    return config?.getValue(RemoteConfigConstants.mapMarkerTypes).asString();
  }

  static Future<String?> getThermalStatusData() async {
    final config = await _config?.future;

    return config?.getValue(RemoteConfigConstants.thermalConfig).asString();
  }

  /// Returns the JSON string for dynamic-POI per-geometry-type zoom windows.
  /// Expected shape:
  /// `{"marker": {"min_zoom": 13, "max_zoom": 22},
  ///   "polygon": {"min_zoom": 10, "max_zoom": 18}}`.
  /// Callers must fall back to a hardcoded default if null/empty/malformed.
  static Future<String?> getDynamicPoiVisibility() async {
    final config = await _config?.future;
    return config?.getValue(RemoteConfigConstants.dynamicPoiVisibility).asString();
  }

  /// Returns the JSON string for the satellite raster tile overlay.
  /// Expected shape:
  /// `{"layer_name": "satellite",
  ///   "url_template": "https://.../tile/{z}/{y}/{x}?token={TOKEN}",
  ///   "token": "...",
  ///   "expires": 1784245894893}`.
  /// `expires` is milliseconds since epoch and is informational — the
  /// controller logs a warning when the token is past expiry. Token is
  /// substituted into url_template at runtime so it can rotate without
  /// changing the URL field.
  ///
  /// Falls back to [kSatelliteConfigBundledDefault] when Firebase Remote Config
  /// failed to initialize or returned an empty value, so the satellite
  /// layer works offline / before Firebase Console is wired up.
  static Future<String?> getSatelliteConfig() async {
    final snapshot = await getSatelliteConfigSnapshot();
    return snapshot.raw.isEmpty ? kSatelliteConfigBundledDefault : snapshot.raw;
  }

  /// Returns the raw FRC value together with its source flag — lets the
  /// caller distinguish a `valueRemote` (server-supplied) value from a
  /// `valueDefault` (bundled in `setDefaults`) one. When Firebase Remote
  /// Config failed to initialize, returns the bundled default with source
  /// `valueStatic` so the caller doesn't have to special-case nulls.
  static Future<({String raw, ValueSource source})> getSatelliteConfigSnapshot() async {
    final config = await _config?.future;
    if (config == null) {
      return (raw: kSatelliteConfigBundledDefault, source: ValueSource.valueStatic);
    }
    final value = config.getValue(RemoteConfigConstants.satelliteConfig);
    return (raw: value.asString(), source: value.source);
  }

  /// BALADY-3754: whether the Default/Satellite base-map tiles are shown in
  /// the layers sheet. Defaults to `false` (hidden) — both via `setDefaults`
  /// and when Firebase Remote Config failed to initialize.
  static Future<bool> isBaseMapSwitcherEnabled() async {
    final config = await _config?.future;
    return config?.getValue(RemoteConfigConstants.baseMapSwitcherEnabled).asBool() ?? false;
  }

  static Future<void> _saveAppConfig(FirebaseRemoteConfig? remoteConfig, EnvType envType) async {
    /// Fetch the vendor configuration for the current environment type
    final vendorConfigResponse = remoteConfig?.getValue(envType.vendorConfigKey()).asString();

    /// Open the local Hive storage to save the configuration
    final box = await Hive.openBox(MapnessConstants.envConfigBoxKey);

    /// Check if the remote config is available
    if (vendorConfigResponse != null && vendorConfigResponse.isNotEmpty) {
      /// Convert the value to JSON and save it to the local storage
      await box.put(MapnessConstants.vendorConfigKey, vendorConfigResponse);
    } else {
      /// If the remote config is not available, load the local configuration from assets
      final vendorConfigAsset = await rootBundle.loadString('assets/maps/configs/${envType.vendorConfigPath()}');
      await box.put(MapnessConstants.vendorConfigKey, vendorConfigAsset);
    }

    /// Save the environment type key to Hive for future reference
    await box.put(MapnessConstants.envTypeKey, envType.appConfigKey());

    /// Save all env config to hive just for testing scenario
    /// Optionally save all environment config to Hive for testing purposes
    final envConfigResponse = remoteConfig?.getValue(MapnessConstants.firebaseAppEnvConfigKey).asString();
    if (envConfigResponse != null && envConfigResponse.isNotEmpty) {
      await box.put(MapnessConstants.firebaseAppEnvConfigKey, envConfigResponse);
    } else {
      final envJsonString = jsonEncode(envType.getLocalEnvConfig().toJson());
      await box.put(MapnessConstants.firebaseAppEnvConfigKey, envJsonString);
    }
  }
}
