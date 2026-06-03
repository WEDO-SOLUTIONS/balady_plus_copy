import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_models.dart';
import 'package:mapness/shared/config/environment_config.dart';

/// Bbox forwarded as `viewpoint1=lon,lat&viewpoint2=lon,lat`. Backend treats
/// viewpoint1 as the top-left and viewpoint2 as the bottom-right, so lat
/// values are passed in descending order.
class DynamicPoiBbox {
  const DynamicPoiBbox({
    required this.northLat,
    required this.southLat,
    required this.westLon,
    required this.eastLon,
  });

  final double northLat;
  final double southLat;
  final double westLon;
  final double eastLon;

  /// Expands the bbox by `gap` (fraction of width/height on each side) so
  /// the next pan typically lands inside cached data.
  DynamicPoiBbox padded(double gap) {
    final dLat = (northLat - southLat).abs() * gap;
    final dLon = (eastLon - westLon).abs() * gap;
    return DynamicPoiBbox(
      northLat: northLat + dLat,
      southLat: southLat - dLat,
      westLon: westLon - dLon,
      eastLon: eastLon + dLon,
    );
  }
}

class DynamicPoiDatasource {
  DynamicPoiDatasource({required this.dio, required this.env});

  final Dio dio;
  final DgisEnv env;

  Future<List<DynamicPoi>> fetchMarkers({
    required String locale,
    int pageSize = 500,
    DynamicPoiBbox? bbox,
    CancelToken? cancelToken,
  }) async {
    final config = env.getConfig();
    // env.url is `https://<host>/api/1.0/`. The dynamic-markers endpoint
    // lives at `<host>/1.0/dynamic-markers` (no `/api/`), so we drop the
    // path and rebuild from the origin.
    final origin = Uri.parse(config.url).origin;
    final url = '$origin/1.0/dynamic-markers';

    final params = <String, dynamic>{
      'locale': locale,
      'page_size': pageSize,
    };
    if (bbox != null) {
      // viewpoint1 = top-left (W,N); viewpoint2 = bottom-right (E,S).
      params['viewpoint1'] = '${bbox.westLon},${bbox.northLat}';
      params['viewpoint2'] = '${bbox.eastLon},${bbox.southLat}';
    }

    final response = await dio.get<dynamic>(
      url,
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const [];
    }

    final features = data['features'];
    if (features is! List) {
      return const [];
    }

    final pois = <DynamicPoi>[];
    for (final raw in features) {
      if (raw is! Map<String, dynamic>) {
        continue;
      }
      final poi = DynamicPoi.fromGeoJson(raw);
      if (poi == null) {
        continue;
      }
      pois.add(poi);
    }
    return pois;
  }
}
