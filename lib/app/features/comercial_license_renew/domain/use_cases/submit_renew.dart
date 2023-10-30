import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../commercial_license_cancel/data/models/submit_response.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;

class SubmitRenew extends UseCase<ResponseBodyModel<SubmitResponse>, int> {
  final RenewCrRepository repository;

  SubmitRenew({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<SubmitResponse>>> call(
      int params) async {
    return await repository.submitRenew(params: params);
  }
}
