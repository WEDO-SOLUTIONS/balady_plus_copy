import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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


  // void startTrackingService() {
  //
  //   LocationSettings? locationSettings;
  //   if (Platform.isAndroid) {
  //      locationSettings = AndroidSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 5,
  //       forceLocationManager: true,
  //     );
  //   } else if (Platform.isIOS) {
  //     locationSettings = AppleSettings(
  //       accuracy: LocationAccuracy.best,
  //       distanceFilter: 5,
  //       activityType: ActivityType.otherNavigation,
  //     );
  //   }
  //   // positionStream = geoLocator.Geolocator.getPositionStream(
  //   //         locationSettings: geoLocator.LocationSettings(distanceFilter: 5))
  //   //     .listen((event) {
  //   //   latitde = event.latitude;
  //   //   longtitude = event.longitude;
  //   // });
  //
  //   positionStream = Geolocator.getPositionStream(
  //     locationSettings: locationSettings,
  //   ).listen(
  //         (Position position) {
  //
  //        latitde = position.latitude;
  //       longtitude = position.longitude;
  //
  //     },
  //   );
  //
  // }
  //
  // _getCurrentLocation(int requestId) {
  //
  //   Geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     latitde = position.latitude;
  //     longtitude = position.longitude;
  //
  //   }).whenComplete((){
  //
  //
  //
  //
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }




  // void startTrackingUpdate() async {
  //   bool? locationConsent = sharedPrefs.getLocationConsent();
  //
  //
  //     await BackgroundLocation.stopLocationService();
  //     double distanceFilter = Platform.isAndroid ? 0.0 : 0.0;
  //     await BackgroundLocation.startLocationService(
  //         distanceFilter: distanceFilter);
  //
  //     BackgroundLocation.getLocationUpdates((location) async {
  //       if (location.latitude == null) return;
  //
  //       latitde = location.latitude;
  //       longtitude = location.longitude;
  //
  //
  //     });
  //   //  getLocationOnlyOneTime();
  //
  // }
  //



  void stopTracking() {
    BackgroundLocation.stopLocationService();
  }



  void startTimer(int requestId) {

    if (startTracking) {
    //  startTrackingService();
      if (longtitude != null && latitde != null) {
        updateDriverLocation(
            UpdateDriverLocationParams(x: longtitude!, y: latitde!,requestId: requestId));
      }

      _timer = Timer.periodic(Duration(minutes: 1), (Timer t) async {

        LatLng? location = await Helpers.getCurrentLocation(
            accuracy: LocationAccuracy.medium,
            duration: const Duration(seconds: 30));

        if (location?.longitude != null && location?.latitude != null) {
          updateDriverLocation(
              UpdateDriverLocationParams(x: location!.longitude, y: location.latitude,requestId: requestId));
        }


      });

    }
  }

  void start(int requestId) {
    startTracking = true;
   // startTrackingUpdate();
    startTimer(requestId);

  }

  void stop() {
    startTracking = false;
    cancelTimer();
    BackgroundLocation.stopLocationService();
  }

  void cancelTimer() {
    print("Locatioin Servvice Cancel");
    _timer?.cancel();
    positionStream?.cancel();
  }
}
