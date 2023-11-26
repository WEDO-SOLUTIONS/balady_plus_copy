import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/trip_details.dart';
import '../repositories/ekram_repository.dart';

class GetTrips extends UseCase<ResponseBodyModel<List<TripDetails>>, int> {
  final EkramRepository repository;

  GetTrips({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<TripDetails>>>> call(
      int params) async {
    return await repository.getTrips(params);
  }
}
