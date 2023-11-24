import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location.g.dart';

@riverpod
class _Location extends _$Location {
  @override
  GeoPointMessage? build() {
    const locationSettings = LocationSettings(accuracy: LocationAccuracy.best);
    final locationSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (event) {
        state = GeoPointMessage(
          latitude: event.latitude,
          longitude: event.longitude,
        );
      },
    );
    ref.onDispose(() {
      locationSubscription.cancel();
    });

    return null;
  }
}

final locationProvider = _locationProvider;
