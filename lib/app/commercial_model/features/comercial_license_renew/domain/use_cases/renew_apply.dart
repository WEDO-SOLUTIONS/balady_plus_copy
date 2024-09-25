import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../renew_commercial_license_exports.dart'
    show RenewCrRepository, RenewApplyRequest;

class RenewApply extends UseCase<ResponseBodyModel<int>, RenewApplyRequest> {
  final RenewCrRepository repository;

  RenewApply({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<int>>> call(
      RenewApplyRequest params) async {
    return await repository.renewApply(params: params);
  }
}
