import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/weather_alerts_request_model.dart';
import '../repository/weather_alerts_repository.dart';

class GetWeatherAlerts extends UseCase<bool, WeatherAlertRequestModel> {
  final WeatherAlertsRepository repository;
  GetWeatherAlerts({required this.repository});
  @override
  Future<Either<Failure, bool>> call(WeatherAlertRequestModel params) async {
    return await repository.sendLocationToGetWeatherAlerts(params);
  }
}
