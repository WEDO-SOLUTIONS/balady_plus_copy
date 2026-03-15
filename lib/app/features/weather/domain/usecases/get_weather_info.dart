import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    show WeatherParams, AllWeatherInfoEntity, WeatherRepository;

import 'package:dartz/dartz.dart' show Either;

class GetWeatherInfo extends UseCase<AllWeatherInfoEntity, WeatherParams> {
  final WeatherRepository repository;

  GetWeatherInfo({required this.repository});
  @override
  Future<Either<Failure, AllWeatherInfoEntity>> call(
      WeatherParams params) async {
    return await repository.getAllWeatherInfoForLocation(params: params);
  }
}
