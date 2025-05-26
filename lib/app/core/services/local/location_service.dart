import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';



import '../../../features/ekram/domain/entities/update_driver_location_params.dart';
import '../../../features/ekram/domain/use_cases/update_driver_location.dart';
import '../../dependency_injection/injection_container.dart';

class EkramLocationService {
  static double? latitde;
  static double? longtitude;

  UpadateDriverLocation updateDriverLocation = UpadateDriverLocation(repository: sl());
  bool startTracking = false;

  Future<void> StartTracking(int requestId) async {
    if(startTracking) {
      // await BackgroundLocation.setAndroidNotification(
      //   title: 'Background service is running',
      //   message: 'Background location in progress',
      //   icon: '@mipmap/ic_launcher',
      // );
      //await BackgroundLocation.setAndroidConfiguration(1000);
      await BackgroundLocation.startLocationService(
          distanceFilter: 200);
      BackgroundLocation.getLocationUpdates((location) {
        if (location.longitude != null && location.latitude != null) {
          updateDriverLocation(
              UpdateDriverLocationParams(x: location.longitude!,
                  y: location.latitude!,
                  requestId: requestId));
        }
      });
    }
  }



  void start(int requestId) {
    startTracking = true;
    StartTracking(requestId);

  }

  void stop() {
    startTracking = false;
    BackgroundLocation.stopLocationService();
  }


}
