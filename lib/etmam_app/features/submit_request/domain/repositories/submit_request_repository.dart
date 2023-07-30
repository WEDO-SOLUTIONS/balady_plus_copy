import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_response.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class SubmitRequestRepository {
  Future<Either<Failure, ApigeeResponse<SubmitRespone>>> submitRequest(
      {required SubmitParams params});
}
