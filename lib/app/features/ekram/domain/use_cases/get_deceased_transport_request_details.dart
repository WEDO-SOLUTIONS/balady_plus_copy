import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/deceased_request_details/deceased_request_details.dart';
import '../repositories/ekram_repository.dart';
import 'package:dartz/dartz.dart' show Either;

class GetDeceasedTransportRequestDetails
    extends UseCase<ResponseBodyModel<DeceasedRequestDetails>, int> {
  final EkramRepository repository;

  GetDeceasedTransportRequestDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>> call(
      int params) async {
    return await repository.getDeceasedTransportRequestDetails(params);
  }
}
