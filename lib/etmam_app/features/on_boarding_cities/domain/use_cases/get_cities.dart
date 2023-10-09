import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase, NoParams;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CityResponse;
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show CityRepository;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../entities/city_params.dart';

class GetCities extends UseCase<ApigeeResponse<CityResponse>, CityParams> {
  final CityRepository repository;

  GetCities({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<CityResponse>>> call(
      CityParams params) async {
    return await repository.getCities(params);
  }
}
