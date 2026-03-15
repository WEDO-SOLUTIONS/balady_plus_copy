import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;

import '../../weather_exports.dart' show AllWeatherInfoEntity, WeatherParams;

abstract class WeatherRepository {
  Future<Either<Failure, AllWeatherInfoEntity>> getAllWeatherInfoForLocation({required WeatherParams params});
}
