import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/trip_location_response.dart';
import '../repositories/ekram_repository.dart';

class GetTripsLocation
    extends UseCase<ResponseBodyModel<TripLocationsResponse>, int> {
  final EkramRepository repository;

  GetTripsLocation({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<TripLocationsResponse>>> call(
      int params) async {
    return await repository.getTripsLocation(params);
  }
}
