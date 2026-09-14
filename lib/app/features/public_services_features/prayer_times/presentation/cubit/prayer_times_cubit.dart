import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/use_cases/get_gis_data.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus, CommonFunctions, Prayers;
import '../../prayer_times_exports.dart'
    show
        GetPrayerTimes,
        GetPrayerTimesRange,
        PrayerTimeEntity,
        PrayerTimeRangeEntity,
        PrayerTimeRangeParams,
        PrayerTimesParams,
        PrayerTimesResponse;

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final GetPrayerTimes _getPrayerTimes;
  final GetPrayerTimesRange _getPrayerTimesRange;

  PrayerTimesCubit({
    required GetPrayerTimes getPrayerTimes,
    required GetGISData getGISData,
    required GetPrayerTimesRange getPrayerTimesRange,
  }) : _getPrayerTimes = getPrayerTimes,
       _getPrayerTimesRange = getPrayerTimesRange,
       super(const PrayerTimesState()) {
    getPrayerTime();
    getPrayerSettings();
    getPrayerTimeRange();
  }

  Future<bool> checkExactAlarmPermission() async {
    if ((await Permission.scheduleExactAlarm.request()).isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void setNotifications() async {
    await checkExactAlarmPermission();
    final isNotificationTurnOff = !state.prayerTimeSettings.contains("1");
    if (isNotificationTurnOff) return NotificationService.cancelAll();

    for (var prayer in state.prayersRange) {
      state.prayerTimeSettings[0] == "1"
          ? NotificationService.showScheduledNotification(
              id: prayer.fajrId,
              title: "fajrAzan".tr(),
              scheduledDate: prayer.fajrDateTime,
            )
          : NotificationService.cancel(prayer.fajrId);
      state.prayerTimeSettings[1] == "1"
          ? NotificationService.showScheduledNotification(
              id: prayer.zuhrId,
              title: "zuhrAzan".tr(),
              scheduledDate: prayer.zuhrDateTime,
            )
          : NotificationService.cancel(prayer.zuhrId);
      state.prayerTimeSettings[2] == "1"
          ? NotificationService.showScheduledNotification(
              id: prayer.asrId,
              title: "asrAzan".tr(),
              scheduledDate: prayer.asrDateTime,
            )
          : NotificationService.cancel(prayer.asrId);
      state.prayerTimeSettings[3] == "1"
          ? NotificationService.showScheduledNotification(
              id: prayer.magribId,
              title: "magribAzan".tr(),
              scheduledDate: prayer.magribDateTime,
            )
          : NotificationService.cancel(prayer.magribId);
      state.prayerTimeSettings[4] == "1"
          ? NotificationService.showScheduledNotification(
              id: prayer.ishaId,
              title: "ishaAzan".tr(),
              scheduledDate: prayer.ishaDateTime,
            )
          : NotificationService.cancel(prayer.ishaId);
    }
  }

  void getPrayerSettings() => emit(state.copyWith(prayerTimeSettings: sharedPrefs.getPrayerSettings()));

  void onChangePrayerSettings(int index) {
    final newPrayerSettings = List.of(state.prayerTimeSettings);
    newPrayerSettings.replaceRange(index, index + 1, [newPrayerSettings[index] == "0" ? "1" : "0"]);

    emit(state.copyWith(prayerTimeSettings: newPrayerSettings));
    sharedPrefs.setPrayerSettings(newPrayerSettings);
    setNotifications();
  }

  void prayerSettingsOnOff() {
    final newPrayerSettings = List.of(
      state.prayerTimeSettings,
    ).map((e) => state.isNotificationDisable ? "1" : "0").toList();

    emit(state.copyWith(prayerTimeSettings: newPrayerSettings));
    sharedPrefs.setPrayerSettings(newPrayerSettings);
    setNotifications();
  }

  void getPrayerTimeRange() async {
    await Helpers.getCurrentLocation();

    if (CommonProperties.userLocation == null) return;
    final params = PrayerTimeRangeParams(
      startDate: DateFormat("dd/MM/yyyy").format(DateTime.now()),
      endDate: DateFormat("dd/MM/yyyy").format(DateTime.now().copyWith(day: DateTime.now().day + 5)),
      dateType: 'GRG',
      isFormat24Hours: "true",
      lat: CommonProperties.userLocation != null ? CommonProperties.userLocation!.y.toString() : "21.424236910931974",
      lng: CommonProperties.userLocation != null ? CommonProperties.userLocation!.x.toString() : "39.82589070176908",
    );

    final failureOrSuccess = await _getPrayerTimesRange(params);

    failureOrSuccess.fold((failure) {}, (prayersRange) {
      emit(state.copyWith(prayersRange: prayersRange));
      setNotifications();
      // setNotifications();
    });
  }

  void getPrayerTime() async {
    DateTime? dateToCheck = state.lastUpdatedDate;

    if (dateToCheck != null) {
      //  if (aDate != today || aDate == null || state.prayerTimesResponse == null) {

      CommonFunctions.checkLocationSettings(NavigationService.navigatorKey.currentContext!);
    }
    emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));

    GISParams? userLocation = CommonProperties.userLocation;

    if (CommonProperties.userLocation == null) {
      LatLng? locaton = await Helpers.getCurrentLocation(accuracy: LocationAccuracy.low);

      userLocation = GISParams(x: locaton?.longitude ?? 39.82589070176908, y: locaton?.latitude ?? 21.424236910931974);
      if (locaton == null) {
        emit(state.copyWith(userLocationUnkown: true));
      } else {
        emit(state.copyWith(userLocationUnkown: false));
      }
    } else {
      emit(state.copyWith(userLocationUnkown: false));
    }

    final params = PrayerTimesParams(latitude: userLocation!.lat, longitude: userLocation.lon, date: DateTime.now());
    final failureOrSuccess = await _getPrayerTimes(params);

    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            prayerTimes: response,
            lastUpdatedDate: DateTime.now(),
          ),
        );
      },
    );
    /*return;

      bool checkLoccationSettings = await CommonFunctions.checkLocationSettings(
          NavigationService.navigatorKey.currentContext!);

      LatLng? position = await Helpers.getCurrentLocation();
      double latitude = 21.424236910931974;
      double longitude = 39.82589070176908;
      if (position != null) {
        emit(state.copyWith(userLocationUnkown: false));

        latitude = position.latitude;
        longitude = position.longitude;
      } else {
        emit(state.copyWith(userLocationUnkown: true));
      }

      emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
      final gisFailureOrSuccess = await _getGISData(
        GISParams(x: longitude, y: latitude),
      );

      gisFailureOrSuccess.fold(
        (failure) {
          emit(state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (response) {
          emit(state.copyWith(
            gisResponse: response,
          ));
        },
      );

      if (gisFailureOrSuccess.isLeft()) return;

      emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
      final params = PrayerTimesParams(
        latitude: latitude,
        longitude: longitude,
        date: DateTime.now(),
      );
      final failureOrSuccess = await _getPrayerTimes(params);

      await failureOrSuccess.fold(
        (failure) {
          emit(state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (response) {
          emit(state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              prayerTimes: response,
              lastUpdatedDate: DateTime.now()));
        },
      );*/
    // }

    updateNextPrayer();
  }

  void updateNextPrayer() {
    if (state.prayerTimesResponse == null) return;
    final now = DateTime.now();
    if (now.isAfter(state.prayerTimesResponse!.isha.dateTime)) {
      emit(state.copyWith(nextPrayer: state.prayerTimesResponse!.fajr));
    } else if (now.isAfter(state.prayerTimesResponse!.maghrib.dateTime)) {
      emit(state.copyWith(nextPrayer: state.prayerTimesResponse!.isha));
    } else if (now.isAfter(state.prayerTimesResponse!.asr.dateTime)) {
      emit(state.copyWith(nextPrayer: state.prayerTimesResponse!.maghrib));
    } else if (now.isAfter(state.prayerTimesResponse!.dhuhr.dateTime)) {
      emit(state.copyWith(nextPrayer: state.prayerTimesResponse!.asr));
    } else if (now.isAfter(state.prayerTimesResponse!.fajr.dateTime)) {
      emit(state.copyWith(nextPrayer: state.prayerTimesResponse!.dhuhr));
    } else {
      emit(state.copyWith(nextPrayer: state.prayerTimesResponse!.fajr));
    }
    // final nextPrayerTimeDiff = state.nextPrayer!.dateTime.difference(now);
  }
}
