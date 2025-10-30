import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show MyOrdersRepository, RatingItem;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetRatingItems
    extends UseCase<ApigeeResponse<List<RatingItem>>, NoParams> {
  final MyOrdersRepository repository;

  GetRatingItems({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<List<RatingItem>>>> call(
      NoParams params) async {
    return await repository.getRatingItems();
  }
}
