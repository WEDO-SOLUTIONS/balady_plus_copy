import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'hajj_rcmc_provider.g.dart';

final hajjRcmcProvider = _hajjRcmcProvider;

@riverpod
class _HajjRcmc extends _$HajjRcmc {
  final _settings = MapObjectManagerSettings.hajj();
  final _refreshTimer = const Duration(minutes: 10);
  late final _rcmcUrl = 'rcmc-markers?p1=39.643626,21.637784&p2=40.036879,21.198644';
  late final _zoomInVisibleMarkers = 12.0;

  List<PoiMarkerRcmc>? _cached;
  Language? _cacheLanguage;
  Timer? _timer;

  Dio get _dio => ref.read(baseDioProvider)
    ..interceptors.clear()
    ..interceptors.add(
      TalkerDioLogger(
        talker: logger is TalkerMapnessLogger ? (logger as TalkerMapnessLogger).talker : null,
        settings: const TalkerDioLoggerSettings(
          printResponseData: false,
        ),
      ),
    );

  MapObjectManager get _objectManager => ref.watch(
        mapObjectManagerProvider(
          named: _settings.name,
          layerId: _settings.layerId,
        ).notifier,
      );

  @override
  Future<List<PoiMarkerRcmc>> build() async {
    ref.onDispose(() {
      _timer?.cancel();
    });

    _startAutoRefresh();
    return _fetchMarkers();
  }

  Future<List<PoiMarkerRcmc>> _fetchMarkers() async {
    try {
      final env = await ref.read(dgisEnvironmentProvider.future);
      final String url = env.url.replaceFirst('/api', '') + _rcmcUrl;
      final appLanguage = ref.watch(appLanguageProvider);
      final camera = ref.watch(cameraPositionProvider);
      if (camera != null && camera.zoom < _zoomInVisibleMarkers) {
        return [];
      }

      if (_cached != null && _cacheLanguage == appLanguage) {
        return _cached ?? [];
      }

      if (_cacheLanguage != appLanguage) {
        await _objectManager.removeAllMarkers();
      }

      _cached = [];
      _cacheLanguage = appLanguage;

      _dio.options.headers = {'X-Language': appLanguage.baladyCompat};
      final response = await _dio.get(url);

      final List<dynamic> jsonList = response.data;
      final result = jsonList.map((e) => PoiMarkerRcmc.fromJson(e)).toList();
      _cached = result;

      state = AsyncValue.data(result);
      return result;
    } catch (e) {
      state = const AsyncValue.data([]);
      return _cached = [];
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(_refreshTimer, (_) {
      _cached = null;
      ref.invalidateSelf();
    });
  }
}
