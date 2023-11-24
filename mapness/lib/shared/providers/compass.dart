import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_compass/flutter_compass.dart';

part 'compass.g.dart';

@riverpod
class Compass extends _$Compass {
  @override
  double build() {
    final compassSubscription = FlutterCompass.events?.listen((event) {
      final bearing = event.heading ?? 0;
      state = bearing;
    });
    ref.onDispose(() {
      compassSubscription?.cancel();
    });

    return 0;
  }
}
