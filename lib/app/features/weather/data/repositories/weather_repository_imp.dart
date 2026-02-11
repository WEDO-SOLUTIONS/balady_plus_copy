import 'package:balady_plus/app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:balady_plus/app/features/weather/data/datasources/weather_remote_datasource.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../weather_exports.dart'
    show WeatherRepository, AllWeatherInfoEntity, WeatherParams;
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;

  WeatherRepositoryImpl(
      this.weatherRemoteDataSource, this.weatherLocalDataSource);

  @override
  Future<Either<Failure, AllWeatherInfoEntity>> getAllWeatherInfoForLocation(
      {required WeatherParams params}) async {
    try {
      final data = await weatherRemoteDataSource.getAllWeatherInfoForLocation(
          params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
