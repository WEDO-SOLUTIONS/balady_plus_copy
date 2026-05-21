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

class AppConfigLoader {
  AppConfigLoader._();

  static Completer<FirebaseRemoteConfig?>? _config;

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
          fetchTimeout: const Duration(hours: 1),
          minimumFetchInterval: const Duration(minutes: 2),
        ),
      );

      /// Ensure Remote Config is initialized and activate the config values
      await remoteConfig.ensureInitialized();
      await remoteConfig.fetchAndActivate();

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
