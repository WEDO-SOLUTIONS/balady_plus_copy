import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hajj_rcmc_provider.g.dart';

final hajjRcmcProvider = _hajjRcmcProvider;

@riverpod
class _HajjRcmc extends _$HajjRcmc {
  final _refreshTimer = const Duration(minutes: 10);
  late final _rcmcUrl = 'rcmc-markers?p1=39.643626,21.637784&p2=40.036879,21.198644';
  late final _zoomInVisibleMarkers = 11.0;

  List<PoiMarkerRcmc>? _cached;
  Language? _cacheLanguage;
  Timer? _timer;

  Dio get dio => ref.read(baseDioProvider)
    ..interceptors.clear()
    ..interceptors.add(
      PrettyDioLogger(responseBody: false),
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

      _cached = [];
      _cacheLanguage = appLanguage;

      dio.options.headers = {'X-Language': appLanguage.baladyCompat};
      final response = await dio.get(url);

      final List<dynamic> jsonList = response.data;
      final result = jsonList.map((e) => PoiMarkerRcmc.fromJson(e)).toList();
      _cached = result;

      return result;
    } catch (e) {
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
