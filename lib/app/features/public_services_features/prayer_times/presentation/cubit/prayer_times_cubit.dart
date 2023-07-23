import 'dart:async';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, CommonFunctions;
import '../../../../vd/vd_exports.dart' show GISParams, GISResponse, GetGISData;
import '../../prayer_times_exports.dart'
    show
        GetPrayerTimes,
        PrayerTimeEntity,
        PrayerTimesParams,
        PrayerTimesResponse;

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final GetPrayerTimes _getPrayerTimes;
  final GetGISData _getGISData;

  PrayerTimesCubit({
    required GetPrayerTimes getPrayerTimes,
    required GetGISData getGISData,
  })  : _getPrayerTimes = getPrayerTimes,
        _getGISData = getGISData,
        super(const PrayerTimesState()) {
    getPrayerTime();
  }

  void getPrayerTime() async {
    // request permission
    /* final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      emit(state.copyWith(
        status: BlocRequestStatus.submissionGetFailure,
        errorMessage: "locationServiceDisabled".tr(),
      ));
      return;
    }
    */

    bool isEnabled = await CommonFunctions.checkLocationSettings(
        NavigationService.navigatorKey.currentContext!);
    if (!isEnabled) return;
    late LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      emit(state.copyWith(
        status: BlocRequestStatus.submissionGetFailure,
        errorMessage: "permissionDenied".tr(),
      ));
      return;
    }

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
        ));
      },
    );
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
    final nextPrayerTimeDiff = state.nextPrayer!.dateTime.difference(now);
    Timer.periodic(nextPrayerTimeDiff, (timer) {
      updateNextPrayer();
      timer.cancel();
    });
  }
}
