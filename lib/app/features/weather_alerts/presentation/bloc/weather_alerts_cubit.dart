import 'package:background_location/background_location.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../data/models/weather_alerts_request_model.dart';
import '../../domain/usecase/get_weather_alerts.dart';
import 'dart:math';

part 'weather_alerts_state.dart';

class WeatherAlertsCubit extends Cubit<WeatherAlertsState> {
  GetWeatherAlerts _getWeatherAlerts;
  WeatherAlertsCubit()
      : _getWeatherAlerts = GetWeatherAlerts(repository: sl()),
        super(WeatherAlertsState(updateTime: DateTime.now()));

  void startTracking() async {
    await BackgroundLocation.stopLocationService();
    await BackgroundLocation.startLocationService(distanceFilter: 30);
    BackgroundLocation.getLocationUpdates((location) async {
      print("Location_Updates ${location.toMap()}");
      if (location.latitude == null) return;
      //   double prevLat = state.location?.latitude ?? location.latitude!;
      //   double prevLon = state.location?.longitude ?? location.longitude!;

      //bool newUpdate = hasMoved(prevLat, prevLon, location.latitude!,
      //     location.longitude!, location.accuracy ?? 1);

      bool newUpdate = checkDistance(location: location);
      DateTime now = DateTime.now();
      bool updateTime =
          now!.difference(state.updateTime!) >= const Duration(minutes: 1);

      if (newUpdate && updateTime) {
        updateLastLocation(location: location);
        if (CommonProperties.fcmToken != null) {
          _getWeatherAlerts(WeatherAlertRequestModel(
              lat: location.latitude!,
              lon: location.longitude!,
              fcmToken: CommonProperties.fcmToken!));
        }
        SentryEvent event = SentryEvent(
            user: SentryUser(id: "21116925921112"),
            transaction: "Location_Updates_Test11",
            message: SentryMessage("${location.toMap()}"),
            exceptions: [
              SentryException(
                  type: "Location_Updates_Test", value: "Location_Updates_Test")
            ]);
        SentryId id = await Sentry.captureEvent(event, withScope: (p) {
          //  p.addAttachment(attachment)
        });

        print(id);
      }
    });
  }

  void stopTracking() {
    BackgroundLocation.stopLocationService();
  }

  bool checkDistance({required Location location}) {
    if (state.location != null) {
      double distance = CommonFunctions.calculateDistance(
          state.location!.latitude,
          state.location!.longitude,
          location.latitude,
          location.longitude);

      print("distance $distance");
      if (distance >= 25) return true;
      return false;
    }

    return true;
  }

  void updateLastLocation({required Location location}) {
    emit(state.copyWith(status: BlocStatus.loading));
    emit(state.copyWith(
        status: BlocStatus.success,
        location: location,
        updateTime: DateTime.now()));
  }

  bool hasMoved(double previousLat, double previousLon, double newLat,
      double newLon, double accuracy) {
    // Haversine formula to calculate distance between two coordinates
    double calculateHaversine(
        double lat1, double lon1, double lat2, double lon2) {
      const double earthRadius = 6371000.0; // Earth's radius in meters

      double toRadians(double degrees) {
        return degrees * (pi / 180.0);
      }

      double dLat = toRadians(lat2 - lat1);
      double dLon = toRadians(lon2 - lon1);

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(toRadians(lat1)) *
              cos(toRadians(lat2)) *
              sin(dLon / 2) *
              sin(dLon / 2);

      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      return earthRadius * c;
    }

    // Calculate distance between the last known location and the new location
    double distance =
        calculateHaversine(previousLat, previousLon, newLat, newLon);

    // Check if the distance is greater than or equal to 30 meters considering accuracy

    return distance >= 30;
  }
}
