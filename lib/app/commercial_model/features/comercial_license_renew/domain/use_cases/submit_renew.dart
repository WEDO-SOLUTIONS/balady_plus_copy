import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../../commercial_license/data/models/cr_submit_response_model.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;

class SubmitRenew
    extends UseCase<ResponseBodyModel<CrSubmitResponseModel>, int> {
  final RenewCrRepository repository;

  SubmitRenew({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CrSubmitResponseModel>>> call(
      int params) async {
    return await repository.submitRenew(params: params);
  }
}
