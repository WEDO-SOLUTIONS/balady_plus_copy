import 'dart:async';

import 'package:geolocator/geolocator.dart' as geoLocator;

import '../../../features/ekram/domain/entities/update_driver_location_params.dart';
import '../../../features/ekram/domain/use_cases/update_driver_location.dart';
import '../../dependency_injection/injection_container.dart';

class EkramLocationService {
  static double? latitde;
  static double? longtitude;
  static Timer? _timer;
  UpadateDriverLocation updateDriverLocation =
      UpadateDriverLocation(repository: sl());
  bool startTracking = false;
  StreamSubscription<geoLocator.Position>? positionStream;
  void startTrackingService() {
    print("Locatioin Servvice tracking  Start $startTracking");

    positionStream = geoLocator.Geolocator.getPositionStream(
            locationSettings: geoLocator.LocationSettings(distanceFilter: 5))
        .listen((event) {
      latitde = event.latitude;
      longtitude = event.longitude;
    });
  }

  void startTimer() {
    print("Locatioin Servvice Start $startTracking");
    if (startTracking) {
      startTrackingService();
      if (longtitude != null && latitde != null) {
        updateDriverLocation(
            UpdateDriverLocationParams(x: longtitude!, y: latitde!));
      }
      _timer = Timer(Duration(minutes: 1), () {
        if (longtitude != null && latitde != null) {
          updateDriverLocation(
              UpdateDriverLocationParams(x: longtitude!, y: latitde!));
        }
      });
    }
  }

  void start() {
    startTracking = true;
    startTrackingService();
    startTimer();
  }

  void stop() {
    startTracking = false;
    cancelTimer();
  }

  void cancelTimer() {
    print("Locatioin Servvice Cancel");
    _timer?.cancel();
    positionStream?.cancel();
  }
}
