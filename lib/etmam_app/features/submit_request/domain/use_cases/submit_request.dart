import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_response.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart'
    show SubmitRequestRepository;

import '../../../../core/errors/errors_exports.dart' show Failure;

class SubmitRequest
    extends UseCase<ApigeeResponse<SubmitRespone>, SubmitParams> {
  final SubmitRequestRepository repository;

  SubmitRequest({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<SubmitRespone>>> call(
      SubmitParams params) async {
    return await repository.submitRequest(params: params);
  }
}
