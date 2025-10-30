import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;
import '../entities/save_renew_request.dart';

class SaveRenewRequestInfo
    extends UseCase<ResponseBodyModel<dynamic>, SaveRenewRequest> {
  final RenewCrRepository repository;

  SaveRenewRequestInfo({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> call(
      SaveRenewRequest params) async {
    return await repository.saveRenewRequestInfo(params: params);
  }
}
