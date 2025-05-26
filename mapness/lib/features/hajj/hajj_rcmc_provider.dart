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
  late final _rcmcUrl = 'rcmc-markers?p1=39.643626,21.637784&p2=40.036879,21.198644';
  late final _zoomInVisibleMarkers = 11.0;

  List<PoiMarkerRcmc> _cached = <PoiMarkerRcmc>[];
  Language? _cacheLanguage;

  @override
  Future<List<PoiMarkerRcmc>> build() async {
    try {
      final env = await ref.read(dgisEnvironmentProvider.future);
      final String url = (env.url + _rcmcUrl).replaceFirst('/api', '');
      final appLanguage = ref.watch(appLanguageProvider);
      final camera = ref.watch(cameraPositionProvider);
      if (camera != null && camera.zoom < _zoomInVisibleMarkers) {
        return [];
      }

      if (_cached.isNotEmpty && _cacheLanguage == appLanguage) {
        return _cached;
      }

      final dio = ref.read(baseDioProvider);
      dio.options.headers = {'X-Language': appLanguage.baladyCompat};
      dio.interceptors.addAll(
        [
          PrettyDioLogger(
            /// Since protobufs are just binary files what a purpose to print it
            responseBody: false,
          ),
        ],
      );

      final response = await dio.get(url);

      final List<dynamic> jsonList = response.data;
      final result = jsonList.map((e) => PoiMarkerRcmc.fromJson(e)).toList();
      _cached = result;
      _cacheLanguage = appLanguage;

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
