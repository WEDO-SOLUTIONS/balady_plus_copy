import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/mekkah_base_theme.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/makkah_config_staging.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'places_activation_config.g.dart';

class MakkahAreaConfig {
  const MakkahAreaConfig({
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
  });

  final double latitude;
  final double longitude;
  final double radiusKm;

  factory MakkahAreaConfig.fromJson(Map<String, dynamic> json) => MakkahAreaConfig(
    latitude: (json['latitude'] as num?)?.toDouble() ?? 21.3891,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 39.8579,
    radiusKm: (json['radius_km'] as num?)?.toDouble() ?? 25.0,
  );

  static const MakkahAreaConfig defaultConfig = MakkahAreaConfig(
    latitude: 21.3891,
    longitude: 39.8579,
    radiusKm: 25.0,
  );
}

class ThemeConfig {
  const ThemeConfig({
    required this.enabled,
    required this.forceEnabled,
    this.startDate,
    this.endDate,
    this.area,
  });

  final bool enabled;
  final bool forceEnabled;
  final DateTime? startDate;
  final DateTime? endDate;
  final MakkahAreaConfig? area;

  factory ThemeConfig.fromJson(
    Map<String, dynamic> json, {
    bool forceEnabled = false,
  }) {
    // Handle new structure with activation_periods and location
    final activationPeriods = json['activation_periods'] as List<dynamic>? ?? [];
    DateTime? startDate;
    DateTime? endDate;

    if (activationPeriods.isNotEmpty) {
      final firstPeriod = activationPeriods.first as Map<String, dynamic>?;
      if (firstPeriod != null) {
        startDate = firstPeriod['start_date'] != null ? DateTime.tryParse(firstPeriod['start_date'] as String) : null;
        endDate = firstPeriod['end_date'] != null ? DateTime.tryParse(firstPeriod['end_date'] as String) : null;
      }
    }

    final location = json['location'] as Map<String, dynamic>?;
    MakkahAreaConfig? area;
    if (location != null) {
      area = MakkahAreaConfig(
        latitude: (location['latitude'] as num?)?.toDouble() ?? 21.3891,
        longitude: (location['longitude'] as num?)?.toDouble() ?? 39.8579,
        radiusKm: (location['radius_km'] as num?)?.toDouble() ?? 25.0,
      );
    }

    return ThemeConfig(
      enabled: json['enabled'] as bool? ?? false,
      forceEnabled: forceEnabled,
      startDate: startDate,
      endDate: endDate,
      area: area,
    );
  }

  static const ThemeConfig disabled = ThemeConfig(
    enabled: false,
    forceEnabled: false,
  );

  static const ThemeConfig enabledByDefault = ThemeConfig(
    enabled: true,
    forceEnabled: false,
  );
}

class FeatureConfig {
  const FeatureConfig({
    required this.code,
    required this.enabled,
    this.url,
    this.startDate,
  });

  final String code;
  final bool enabled;
  final String? url;
  final DateTime? startDate;

  factory FeatureConfig.fromJson(Map<String, dynamic> json) {
    final options = json['options'] as Map<String, dynamic>? ?? {};
    return FeatureConfig(
      code: json['code'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      url: options['url'] as String?,
      startDate: options['start_date'] != null ? DateTime.tryParse(options['start_date'] as String) : null,
    );
  }

  static const FeatureConfig disabled = FeatureConfig(
    code: '',
    enabled: false,
  );
}

class PlacesActivationConfig {
  const PlacesActivationConfig({
    required this.version,
    required this.base,
    required this.mekkah,
    required this.ramadan,
    required this.foundationDay,
    required this.hajj,
    required this.features,
    this.presentThemes = const {},
  });

  final int version;
  final ThemeConfig base;
  final ThemeConfig mekkah;
  final ThemeConfig ramadan;
  final ThemeConfig foundationDay;
  final ThemeConfig hajj;
  final List<FeatureConfig> features;

  /// Set of theme names that were actually present in the JSON config
  final Set<String> presentThemes;

  FeatureConfig? getFeature(String code) {
    try {
      return features.firstWhere((f) => f.code == code);
    } catch (_) {
      return null;
    }
  }

  factory PlacesActivationConfig.fromJson(Map<String, dynamic> json) {
    final themes = json['themes'] as Map<String, dynamic>? ?? {};
    final forceEnabledTheme = json['force_enabled_theme'] as String? ?? '';
    final featuresJson = json['features'] as List<dynamic>? ?? [];

    // Track which themes are actually in the JSON
    final presentThemes = <String>{};
    if (themes.containsKey('mekkah')) presentThemes.add('mekkah');
    if (themes.containsKey('ramadan')) presentThemes.add('ramadan');
    if (themes.containsKey('foundation_day')) presentThemes.add('foundation_day');
    if (themes.containsKey('hajj')) presentThemes.add('hajj');

    // Check if any theme is force enabled
    final isMekkahForced = forceEnabledTheme == 'mekkah';
    final isRamadanForced = forceEnabledTheme == 'ramadan';
    final isFoundationDayForced = forceEnabledTheme == 'foundation_day';
    final isHajjForced = forceEnabledTheme == 'hajj';

    return PlacesActivationConfig(
      version: json['version'] as int? ?? 1,
      base: ThemeConfig.enabledByDefault,
      mekkah: themes['mekkah'] != null
          ? ThemeConfig.fromJson(
              themes['mekkah'] as Map<String, dynamic>,
              forceEnabled: isMekkahForced,
            )
          : ThemeConfig.enabledByDefault,
      ramadan: themes['ramadan'] != null
          ? ThemeConfig.fromJson(
              themes['ramadan'] as Map<String, dynamic>,
              forceEnabled: isRamadanForced,
            )
          : ThemeConfig.disabled,
      foundationDay: themes['foundation_day'] != null
          ? ThemeConfig.fromJson(
              themes['foundation_day'] as Map<String, dynamic>,
              forceEnabled: isFoundationDayForced,
            )
          : ThemeConfig.enabledByDefault,
      hajj: themes['hajj'] != null
          ? ThemeConfig.fromJson(
              themes['hajj'] as Map<String, dynamic>,
              forceEnabled: isHajjForced,
            )
          : ThemeConfig.disabled,
      features: featuresJson.map((f) => FeatureConfig.fromJson(f as Map<String, dynamic>)).toList(),
      presentThemes: presentThemes,
    );
  }

  static const PlacesActivationConfig defaultConfig = PlacesActivationConfig(
    version: 1,
    base: ThemeConfig.enabledByDefault,
    mekkah: ThemeConfig(
      enabled: true,
      forceEnabled: false,
      area: MakkahAreaConfig.defaultConfig,
    ),
    ramadan: ThemeConfig.disabled,
    foundationDay: ThemeConfig.enabledByDefault,
    hajj: ThemeConfig.disabled,
    features: [],
    presentThemes: {'mekkah', 'foundation_day'},
  );
}

class PlacesActivationConfigDatasource {
  PlacesActivationConfigDatasource({
    required this.dio,
    required this.env,
  });

  final Dio dio;
  final DgisEnv env;

  static const _cacheFileName = 'places_activation_cache.json';
  static const _cacheStagingFileName = 'places_activation_cache_staging.json';

  String? _cacheFilePath;

  bool get _isStaging => MakkahConfigUrls.isStagingEnv(env);
  String get _remoteUrl => MakkahConfigUrls.getConfigUrl(env);
  String get _cacheFile => _isStaging ? _cacheStagingFileName : _cacheFileName;

  Future<PlacesActivationConfig> getConfig() async {
    try {
      final response = await dio.get<dynamic>(
        _remoteUrl,
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
        final config = PlacesActivationConfig.fromJson(json);
        await _saveToCache(jsonEncode(json));

        return config;
      }
    } on DioException catch (e) {
      logger.log(
        'PlacesActivationConfig: Failed to fetch from remote, falling back to cache. Error: $e',
        logLevel: MapnessLogLevel.warning,
      );
    } catch (e) {
      logger.log(
        'PlacesActivationConfig: Unexpected error fetching remote data: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }

    return _loadFromCache();
  }

  Future<String> _getCacheFilePath() async {
    if (_cacheFilePath != null) return _cacheFilePath!;
    final dir = await getApplicationDocumentsDirectory();
    _cacheFilePath = '${dir.path}/$_cacheFile';
    return _cacheFilePath!;
  }

  Future<void> _saveToCache(String jsonOutput) async {
    try {
      final path = await _getCacheFilePath();
      final file = File(path);
      await file.writeAsString(jsonOutput);
    } catch (e) {
      logger.log(
        'PlacesActivationConfig: Failed to save cache: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
  }

  Future<PlacesActivationConfig> _loadFromCache() async {
    try {
      final path = await _getCacheFilePath();
      final file = File(path);
      if (await file.exists()) {
        final jsonOutput = await file.readAsString();
        final json = jsonDecode(jsonOutput) as Map<String, dynamic>;
        final config = PlacesActivationConfig.fromJson(json);

        return config;
      }
    } catch (e) {
      logger.log(
        'PlacesActivationConfig: Failed to load from cache, falling back to assets: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
    return _loadFromAssets();
  }

  Future<PlacesActivationConfig> _loadFromAssets() async {
    try {
      final jsonOutput = await rootBundle.loadString(
        'packages/mapness/assets/config.json',
      );
      final json = jsonDecode(jsonOutput) as Map<String, dynamic>;
      final config = PlacesActivationConfig.fromJson(json);

      return config;
    } catch (e) {
      logger.log(
        'PlacesActivationConfig: Failed to load from assets, using defaults: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
    return PlacesActivationConfig.defaultConfig;
  }
}

@Riverpod(keepAlive: true)
class PlacesActivation extends _$PlacesActivation {
  @override
  Future<PlacesActivationConfig> build() async {
    final dio = ref.watch(baseDioProvider);
    final env = await ref.watch(dgisEnvTypeProvider.future);
    final datasource = PlacesActivationConfigDatasource(dio: dio, env: env);
    return datasource.getConfig();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final dio = ref.read(baseDioProvider);
    final env = await ref.read(dgisEnvTypeProvider.future);
    final datasource = PlacesActivationConfigDatasource(dio: dio, env: env);
    state = AsyncData(await datasource.getConfig());
  }
}

@riverpod
ThemeConfig placesActivationMekkah(Ref ref) {
  final config = ref.watch(placesActivationProvider);
  return config.maybeWhen(
    data: (data) => data.mekkah,
    orElse: () => PlacesActivationConfig.defaultConfig.mekkah,
  );
}

@riverpod
ThemeConfig placesActivationRamadan(Ref ref) {
  final config = ref.watch(placesActivationProvider);
  return config.maybeWhen(
    data: (data) => data.ramadan,
    orElse: () => PlacesActivationConfig.defaultConfig.ramadan,
  );
}

@riverpod
ThemeConfig placesActivationFoundationDay(Ref ref) {
  final config = ref.watch(placesActivationProvider);
  return config.maybeWhen(
    data: (data) => data.foundationDay,
    orElse: () => PlacesActivationConfig.defaultConfig.foundationDay,
  );
}

@riverpod
ThemeConfig placesActivationHajj(Ref ref) {
  final config = ref.watch(placesActivationProvider);
  return config.maybeWhen(
    data: (data) => data.hajj,
    orElse: () => PlacesActivationConfig.defaultConfig.hajj,
  );
}

/// Debug override for pilgrim feature (Kaaba virtual tour).
///
/// When enabled, bypasses the start_date check for the show_pilgrim feature,
/// allowing the Kaaba virtual journey card to be shown regardless of date.
@Riverpod(keepAlive: true)
class PilgrimFeatureDebug extends _$PilgrimFeatureDebug {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}

/// Check if current date is past the feature's start date.
///
/// If the feature has no `start_date`, the gate is open immediately.
bool _isPastStartDate(FeatureConfig? feature) {
  if (feature?.startDate == null) return true;
  return !DateTime.now().isBefore(feature!.startDate!);
}

/// Pilgrim ("Kaaba virtual journey") feature provider.
///
/// Scope is encoded by the presence of `start_date` on the `show_pilgrim`
/// feature entry in remote config:
///   - `start_date` absent  → feature shown **globally** to every user, immediately.
///   - `start_date` present → feature shown **only to users in the Makkah area**
///                            (via [mekkahBaseThemeProvider]) and only on/after that date.
///
/// Returns `null` when the feature is disabled, before its start date, or
/// scoped to Makkah and the user is outside the Makkah area.
@riverpod
FeatureConfig? showPilgrimFeature(Ref ref) {
  final config = ref.watch(placesActivationProvider);
  final debugOverride = ref.watch(pilgrimFeatureDebugProvider);

  final feature = config.maybeWhen(
    data: (data) => data.getFeature('show_pilgrim'),
    orElse: () => null,
  );

  // Debug override bypasses every gate and returns an enabled feature.
  if (debugOverride) {
    return FeatureConfig(
      code: feature?.code ?? 'show_pilgrim',
      enabled: true,
      url: feature?.url ?? 'https://pilgrim.thedatum.ai/kaaba',
    );
  }

  if (feature == null || !feature.enabled) return null;

  // Scope: start_date present → Makkah-only, gated by area and start date.
  if (feature.startDate != null) {
    if (!_isPastStartDate(feature)) return null;
    return ref.watch(mekkahBaseThemeProvider) ? feature : null;
  }

  // Scope: start_date absent → global, immediate.
  return feature;
}
