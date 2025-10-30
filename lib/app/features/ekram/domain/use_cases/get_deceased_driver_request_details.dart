import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../ekram_exports.dart';
import '../repositories/ekram_repository.dart';
import 'package:dartz/dartz.dart' show Either;

class GetDeceasedDriverRequestDetails
    extends UseCase<ResponseBodyModel<DeceasedRequestDetails>, int> {
  final EkramRepository repository;

  GetDeceasedDriverRequestDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>> call(
      int params) async {
    return await repository.getDeceasedDriverRequestDetails(params);
  }
}
