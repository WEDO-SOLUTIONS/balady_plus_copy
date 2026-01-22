import 'package:mapness/entities/city_contain/dto/city_rect.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/features/city_contains/city_contain.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_not_available.g.dart';

@Riverpod(keepAlive: true)
class ServiceNotAvailable extends _$ServiceNotAvailable {
  final List<CityRect> _cities = [
    /// Riyadh border
    const CityRect(
      northEast: LocationPoint(
        latitude: 25.178203,
        longitude: 47.298231,
      ),
      southWest: LocationPoint(
        latitude: 24.29659,
        longitude: 46.3237,
      ),
    ),

    /// Leap 2025 Conf border
    const CityRect(
      northEast: LocationPoint(
        latitude: 25.270154,
        longitude: 46.402921,
      ),
      southWest: LocationPoint(
        latitude: 25.236086,
        longitude: 46.363507,
      ),
    )
  ];

  bool isShown = false;

  /// True - we are in the city and service is available
  /// False - we are out of the city borders and service is not available
  /// By default - true
  @override
  Future<bool> build() async {
    final location = ref.watch(locationProvider);

    if (isShown) {
      return state.value ?? true;
    }

    if (location == null) {
      return true;
    }

    final locationPoint = LocationPoint(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    bool containValue = false;
    for (final city in _cities) {
      containValue = await ref.read(cityContainProvider(city, locationPoint).future);
      if (containValue) {
        break;
      }
    }

    isShown = true;

    return containValue;
  }
}
