import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/weather_alerts_request_model.dart';

abstract class WeatherAlertsRepository {
  Future<Either<Failure, bool>> sendLocationToGetWeatherAlerts(
    WeatherAlertRequestModel params,
  );
}
