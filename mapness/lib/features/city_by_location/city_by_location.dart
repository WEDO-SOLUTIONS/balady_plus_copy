import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'geocoder_data.dart';
import 'lookups_body.dart';

part 'city_by_location.g.dart';

final cityByLocationProvider = _cityByLocationProvider;

@riverpod
class _CityByLocation extends _$CityByLocation {
  @override
  Future<City> build() async {
    final Position? position = ref.read(locationProvider);

    const defaultCity = City(id: '70030076560739975', name: 'Riyadh');

    if (position == null) {
      return defaultCity;
    }

    try {
      final geocoderData = await _admDivCityByPosition(latitude: position.latitude, longitude: position.longitude);

      if (geocoderData.result.items.isEmpty) {
        return defaultCity;
      }

      final item = geocoderData.result.items.first;

      return City.fromJson(item.toJson());
    } on Object {
      return defaultCity;
    }
  }

  Future<GeocoderData> _admDivCityByPosition({required double latitude, required double longitude}) async {
    final vendorConfig = await ref.read(vendorConfigProvider.future);

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));

    final catalogApi = vendorConfig[BaldayDeeplink.catalogKey];
    final key = vendorConfig[BaldayDeeplink.vendorConfigKey];

    final geocodeUrl = BaldayDeeplink.geocodeUrl(catalogApi);

    final geocoderResponse = await dio.get(
      geocodeUrl,
      queryParameters: {
        BaldayDeeplink.longitudeKey: longitude,
        BaldayDeeplink.latitudeKey: latitude,
        BaldayDeeplink.typeKey: BaldayDeeplink.typeAdmDivCity,
        BaldayDeeplink.keyKey: key,
      },
    );

    return GeocoderData.fromJson(geocoderResponse.data);
  }

  Future<City> getCityByLatLng({double? lat, double? lng}) async {
    const defaultCity = City(id: '70030076560739975', name: 'Riyadh');
    if (lat == null || lng == null) {
      return defaultCity;
    }
    final geocoderData = await _admDivCityByPosition(latitude: lat, longitude: lng);

    if (geocoderData.result.items.isEmpty) {
      return defaultCity;
    }

    final item = geocoderData.result.items.first;
    final city = City.fromJson(item.toJson());
    print('amr city.name ${city.name}');
    return city;
  }
}
