import 'package:mapness/entities/city_contain/dto/city_rect.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/features/city_contains/city_contain.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_not_available.g.dart';

@Riverpod(keepAlive: true)
class ServiceNotAvailable extends _$ServiceNotAvailable {
  // We need to store it in Remote Config
  final CityRect rect = const CityRect(
    northEast: LocationPoint(
      latitude: 25.177958,
      longitude: 47.180222,
    ),
    southWest: LocationPoint(
      latitude: 24.379137,
      longitude: 46.324123, // Меньшая долгота
    ),
  );

  bool isShown = false;

  /// True - we are in the city and service is available
  /// False - we are out of the city borders and service is not available
  /// By default - true
  @override
  Future<bool> build() async {
    final location = ref.watch(locationProvider);

    if (isShown) {
      return state.valueOrNull ?? true;
    }

    if (location == null) {
      return true;
    }

    isShown = true;

    final locationPoint = LocationPoint(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    return await ref.read(
          cityContainProvider(rect, locationPoint).future,
        ) ??
        false;
  }
}
