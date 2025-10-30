import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../ekram_exports.dart';
import '../entities/get_requests_params.dart';
import '../repositories/ekram_repository.dart';

class GetDeceasedTransportRequests extends UseCase<
    ResponseBodyModel<TransportRequestResponse>, GetRequestsParams> {
  final EkramRepository repository;

  GetDeceasedTransportRequests({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<TransportRequestResponse>>> call(
      GetRequestsParams params) async {
    return await repository.getDeceasedTransportRequests(params);
  }
}
