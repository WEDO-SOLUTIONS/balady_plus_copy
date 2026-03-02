import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../prayer_times_exports.dart' show PrayerTimeRangeEntity, PrayerTimeRangeParams, PrayerTimesRepository;

class GetPrayerTimesRange implements UseCase<List<PrayerTimeRangeEntity>, PrayerTimeRangeParams> {
  final PrayerTimesRepository repository;

  GetPrayerTimesRange(this.repository);

  @override
  Future<Either<Failure, List<PrayerTimeRangeEntity>>> call(
    PrayerTimeRangeParams params,
  ) async {
    return await repository.getPrayerTimesRange(params);
  }
}
