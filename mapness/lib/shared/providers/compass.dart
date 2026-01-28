import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compass.g.dart';

@riverpod
class Compass extends _$Compass {
  StreamSubscription<CompassEvent>? _compassSubscription;
  Timer? _timer;

  @override
  double? build() {
    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen(_updateState);

    // update subscription if no data received after 10 seconds
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 10), () {
      final updatedBearing = state;
      if (updatedBearing == null) {
        _compassSubscription?.cancel();
        _compassSubscription = FlutterCompass.events?.listen(_updateState);
      }
    });

    ref.onDispose(() {
      _timer?.cancel();
      _compassSubscription?.cancel();
    });

    return null;
  }

  void _updateState(CompassEvent event) {
    double bearing = event.heading ?? 0;
    // final accuracy = event.accuracy ?? -1;
    // if (accuracy > 15 || (!Platform.isIOS && event.accuracy == -1)) {
    //   state = null;
    // }
    if (bearing < 0) {
      // fix wrong bearing
      bearing += 360;
    }
    state = bearing % 361;
  }
}
