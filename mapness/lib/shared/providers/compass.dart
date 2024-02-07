import 'package:flutter_compass/flutter_compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compass.g.dart';

@riverpod
class Compass extends _$Compass {
  @override
  double? build() {
    final compassSubscription = FlutterCompass.events?.listen((event) {
      double bearing = event.heading ?? 0;
      if (bearing < 0) {
        // fix wrong bearing
        bearing += 360;
      }
      state = bearing % 361;
    });
    ref.onDispose(() {
      compassSubscription?.cancel();
    });

    return null;
  }
}
