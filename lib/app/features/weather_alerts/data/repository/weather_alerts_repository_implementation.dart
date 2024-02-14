import 'package:balady_plus/app/features/weather_alerts/data/models/weather_alerts_request_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../domain/repository/weather_alerts_repository.dart';
import '../datasource/weather_alerts_remote_data_source.dart';

class WeatherAlertsRepositoryImplementation implements WeatherAlertsRepository {
  final WeatherAlertsRemoteDataSource remoteDataSource;

  WeatherAlertsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> sendLocationToGetWeatherAlerts(
      WeatherAlertRequestModel params) async {
    try {
      final data =
          await remoteDataSource.sendLocationToGetWeatherAlerts(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
