import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

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

  Future getLocationOnlyOneTime() async {
    Timer(const Duration(minutes: 1), () async {
      LatLng? location = await Helpers.getCurrentLocation(
          accuracy: LocationAccuracy.medium,
          duration: const Duration(minutes: 1));

      if (location != null) {
        if (CommonProperties.fcmToken != null) {
          WeatherAlertRequestModel model = WeatherAlertRequestModel(
              lat: location.latitude,
              lon: location.longitude,
              fcmToken: CommonProperties.fcmToken!);

          _getWeatherAlerts(model);
          sendEventToSentry(model);
        }
      }
    });
  }

  void startTracking() async {
    bool? locationConsent = sharedPrefs.getLocationConsent();

    //if (locationConsent != true && Platform.isAndroid) return;
    if (locationConsent == true) {
      await BackgroundLocation.stopLocationService();
      double distanceFilter = Platform.isAndroid ? 30.0 : 30.0;
      await BackgroundLocation.startLocationService(
          distanceFilter: distanceFilter);

      BackgroundLocation.getLocationUpdates((location) async {
        if (location.latitude == null) return;

        bool newUpdate = checkDistance(location: location);

        DateTime now = DateTime.now();
        bool updateTime =
            now!.difference(state.updateTime!) >= const Duration(minutes: 1);

        if (newUpdate && updateTime) {
          if (CommonProperties.fcmToken != null) {
            updateLastLocation(location: location);
            WeatherAlertRequestModel model = WeatherAlertRequestModel(
                lat: location.latitude!,
                lon: location.longitude!,
                fcmToken: CommonProperties.fcmToken!);
            _getWeatherAlerts(model);
            sendEventToSentry(model);
          }
        }
      });
      getLocationOnlyOneTime();
    }
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

  void sendEventToSentry(WeatherAlertRequestModel model) {
    try {
      SentryUser sentryUser = SentryUser(
          id: CommonProperties.userInfo?.idNo,
          name: CommonProperties.userInfo?.arName,
          email: "");

      SentryEvent event = SentryEvent(
          user: sentryUser,
          request: SentryRequest(data: model.toMap()),
          message: SentryMessage(model.toMap().toString()),
          transaction: ApiUrl.weatherAlerts,
          environment: sl<EnvType>().name,
          exceptions: [SentryException(type: "Log", value: "Log")]);
      Sentry.captureEvent(event, withScope: (p) {
        //  p.addAttachment(attachment)
      });
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }
}
