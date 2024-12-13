import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:urbi_analytics/logger.dart';

class MetroDatasourece {
  final Dio _dio;
  final Map<String, dynamic> _vendorConfig;

  MetroDatasourece(this._dio, this._vendorConfig);

  Future<List<GeoPointMessage>> getMetroLineInfo(String objectId) async {
    try {
      final catalogApi = _vendorConfig[BaldayDeeplink.catalogKey];
      final key = _vendorConfig[BaldayDeeplink.vendorConfigKey];

      final response = await _dio.get(
        '$catalogApi/3.0/items/byid',
        queryParameters: {
          'key': key,
          'id': objectId,
          // 'locale': 'en_SA',
          'fields':
              'items.description,items.geometry.centroid,items.geometry.selection,items.geometry.style,items.timezone_offset,items.context,items.level_count,items.address,items.is_paid,items.access,items.access_comment,items.for_trucks,items.is_incentive,items.paving_type,items.capacity,items.schedule,items.floors,ad,items.rubrics,items.routes,items.platforms,items.directions',
        },
        // result.items.routes.directions.geometry.selection
      );
      final data = response.data;

      if (data['meta']['code'] != 200) {
        log('Error while fetching metro line info');
        return [];
      }
      final result = data['result'] as Map<String, dynamic>;
      final items = result['items'] as List<dynamic>;
      final item = items.first as Map<String, dynamic>;
      final routes = item['routes'] as List<dynamic>;
      final route = routes.first as Map<String, dynamic>;
      final directions = route['directions'] as List<dynamic>;
      final direction = directions.first as Map<String, dynamic>;
      final geometry = direction['geometry'] as Map<String, dynamic>;
      final selection = geometry['selection'] as String;

      return selection
          .substring(11, selection.length - 1)
          .split(',')
          .map((e) => e.split(' '))
          .map((e) => GeoPointMessage(
                latitude: double.parse(e[1]),
                longitude: double.parse(e[0]),
              ))
          .toList();
    } catch (e) {
      log('Error while fetching metro line info: ${e.toString()}');
      return [];
    }
  }
}
