import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/features/saudi_pass/repo/geocoder_data.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_pass_city_by_location_riverpod.g.dart';

final saudiPassCityByLocationProvider = _saudiPassCityByLocationRiverpodProvider;

@riverpod
class _SaudiPassCityByLocationRiverpod extends _$SaudiPassCityByLocationRiverpod {
  @override
  Future<City> build() async {
    final Position? position = ref.read(locationProvider);

    const defaultCity = City(id: '70030076560739975', name: 'Riyadh');

    if (position == null) {
      return defaultCity;
    }

    try {
      final geocoderData = await _admDivCityByPosition((latitude: position.latitude, longitude: position.longitude));

      if (geocoderData.result.items.isEmpty) {
        return defaultCity;
      }

      final item = geocoderData.result.items.first;

      return City.fromJson(item.toJson());
    } on Object {
      return defaultCity;
    }
  }

  Future<GeocoderData> _admDivCityByPosition(({double latitude, double longitude}) position) async {
    final vendorConfig = await ref.read(vendorConfigProvider.future);

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));

    final catalogApi = vendorConfig[BaldayDeeplink.catalogKey];
    final key = vendorConfig[BaldayDeeplink.vendorConfigKey];

    final geocodeUrl = BaldayDeeplink.geocodeUrl(catalogApi);

    final geocoderResponse = await dio.get(
      geocodeUrl,
      queryParameters: {
        BaldayDeeplink.longitudeKey: position.longitude,
        BaldayDeeplink.latitudeKey: position.latitude,
        BaldayDeeplink.typeKey: BaldayDeeplink.typeAdmDivCity,
        BaldayDeeplink.keyKey: key,
      },
    );

    return GeocoderData.fromJson(geocoderResponse.data);
  }
}
