import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/submit_rating_request.dart';
import '../repositories/repository.dart';

class SubmitSelfRatingUC extends UseCase<double, SubmitRatingRequest> {
  final Repository repository;

  SubmitSelfRatingUC({required this.repository});

  @override
  Future<Either<Failure, double>> call(SubmitRatingRequest request) async {
    return await repository.submitRatingItems(request);
  }
}
