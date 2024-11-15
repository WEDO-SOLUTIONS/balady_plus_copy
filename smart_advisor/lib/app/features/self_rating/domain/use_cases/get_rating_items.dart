import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../data/models/rating_items_response.dart';
import '../repositories/repository.dart';

class GetSelfRatingsItems extends UseCase<RatingItemsResponseModel, int> {
  final Repository repository;

  GetSelfRatingsItems({required this.repository});

  @override
  Future<Either<Failure, RatingItemsResponseModel>> call(int request) async {
    return await repository.getRatingItems(request);
  }
}
