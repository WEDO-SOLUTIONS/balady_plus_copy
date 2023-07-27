import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../prayer_times_exports.dart'
    show
        PrayerTimeRangeEntity,
        PrayerTimeRangeParams,
        PrayerTimesParams,
        PrayerTimesRemoteDataSource,
        PrayerTimesRepository,
        PrayerTimesResponse;

class PrayerTimesRepositoryImplementation implements PrayerTimesRepository {
  final PrayerTimesRemoteDataSource remoteDataSource;

  PrayerTimesRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, PrayerTimesResponse>> getPrayerTimes(
      PrayerTimesParams params) async {
    try {
      final data = await remoteDataSource.getPrayerTimes(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<PrayerTimeRangeEntity>>> getPrayerTimesRange(
      PrayerTimeRangeParams params) async {
    try {
      final data = await remoteDataSource.getPrayerTimesRange(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
