import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../prayer_times_exports.dart' show PrayerTimesParams, PrayerTimesRepository, PrayerTimesResponse;

class GetPrayerTimes implements UseCase<PrayerTimesResponse, PrayerTimesParams> {
  final PrayerTimesRepository repository;

  GetPrayerTimes(this.repository);

  @override
  Future<Either<Failure, PrayerTimesResponse>> call(
    PrayerTimesParams params,
  ) async {
    return await repository.getPrayerTimes(params);
  }
}
