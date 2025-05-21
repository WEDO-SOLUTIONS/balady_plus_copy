import 'package:mapness/entities/search/models/search_region_bound.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_region_bound_provider.g.dart';

final searchRegionBoundProvider = _searchRegionBoundProvider;

@riverpod
class _SearchRegionBound extends _$SearchRegionBound {
  @override
  Future<SearchRegionPolygon> build() async {
    try {
      final vendorConfig = await ref.read(vendorConfigProvider.future);
      final dio = ref.read(baseDioProvider);

      final catalogApi = vendorConfig[BaldayDeeplink.catalogKey];
      final key = vendorConfig[BaldayDeeplink.vendorConfigKey];

      final geocodeUrl = BaldayDeeplink.searchBoundRegion(catalogApi);
      final location = ref.read(locationProvider);

      final response = await dio.get(
        geocodeUrl,
        queryParameters: {
          BaldayDeeplink.qKey: '${location?.longitude},${location?.latitude}',
          BaldayDeeplink.fieldsKey: BaldayDeeplink.fieldsValueBounds,
          BaldayDeeplink.keyKey: key,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final result = data['result'] as Map<String, dynamic>;

      return SearchRegionPolygon.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }
}
