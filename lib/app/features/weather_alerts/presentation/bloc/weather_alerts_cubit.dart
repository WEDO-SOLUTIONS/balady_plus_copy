import 'package:background_location/background_location.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/utils/enums/bloc_status.dart';

part 'weather_alerts_state.dart';

class WeatherAlertsCubit extends Cubit<WeatherAlertsState> {
  WeatherAlertsCubit() : super(const WeatherAlertsState());

  void startTracking() async {
    await BackgroundLocation.stopLocationService();

    await BackgroundLocation.startLocationService(distanceFilter: 4);

    BackgroundLocation.getLocationUpdates((location) async {
      print("Location_Updates ${location.toMap()}");

      bool newUpdate = checkDistance(location: location);
      if (newUpdate) {
        updateLastLocation(location: location);
        SentryEvent event = SentryEvent(
            user: SentryUser(id: "2111692592"),
            transaction: "Location_Updates_Test",
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

      if (distance >= 5) return true;
      return false;
    }

    return true;
  }

  void updateLastLocation({required Location location}) {
    emit(state.copyWith(status: BlocStatus.loading));
    emit(state.copyWith(status: BlocStatus.success, location: location));
  }
}
