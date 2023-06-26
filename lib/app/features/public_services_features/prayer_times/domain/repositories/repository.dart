import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../prayer_times_exports.dart'
    show PrayerTimesParams, PrayerTimesResponse;

abstract class PrayerTimesRepository {
  Future<Either<Failure, PrayerTimesResponse>> getPrayerTimes(
    PrayerTimesParams params,
  );
}
