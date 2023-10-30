import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/save_com_submitter_and_owner_request_model.dart';
import '../entities/cr_submit_request.dart';

class SubmitCR
    extends UseCase<ResponseBodyModel<CrSubmitResponse>, CrSubmitRequest> {
  final CrRepository repository;

  SubmitCR({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CrSubmitResponse>>> call(
      CrSubmitRequest params) async {
    return await repository.submitCr(params: params);
  }
}
