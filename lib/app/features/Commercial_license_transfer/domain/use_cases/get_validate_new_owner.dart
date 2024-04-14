import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../entity/validate_owner_entity.dart';
import '../repository/repository.dart';

class GetValidateNewOwner
    extends UseCase<ResponseBodyModel<ValidateOwnerEntity>, (String, String)> {
  final TransferLicenseRepository repository;

  GetValidateNewOwner({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<ValidateOwnerEntity>>> call(
      (String, String) params) async {
    return await repository.validateNewOwner(params.$1, params.$2);
  }
}
