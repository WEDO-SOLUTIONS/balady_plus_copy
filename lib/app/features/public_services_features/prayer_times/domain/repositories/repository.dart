import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../prayer_times_exports.dart'
    show
        PrayerTimeRangeEntity,
        PrayerTimeRangeParams,
        PrayerTimesParams,
        PrayerTimesResponse;

abstract class PrayerTimesRepository {
  Future<Either<Failure, PrayerTimesResponse>> getPrayerTimes(
      PrayerTimesParams params);
  Future<Either<Failure, List<PrayerTimeRangeEntity>>> getPrayerTimesRange(
      PrayerTimeRangeParams params);
}
