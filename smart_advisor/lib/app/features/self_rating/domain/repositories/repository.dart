import '../../data/models/rating_items_response.dart';
import '../entities/submit_rating_request.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class Repository {
  Future<Either<Failure, RatingItemsResponseModel>> getRatingItems(int params);
  Future<Either<Failure, double>> submitRatingItems(SubmitRatingRequest params);
}
