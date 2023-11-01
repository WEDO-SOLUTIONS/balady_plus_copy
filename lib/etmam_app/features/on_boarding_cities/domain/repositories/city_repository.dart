import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, CityResponse;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../entities/city_params.dart';

abstract class CityRepository {
  Future<Either<Failure, ApigeeResponse<CityResponse>>> getCities(
      CityParams params);
}
