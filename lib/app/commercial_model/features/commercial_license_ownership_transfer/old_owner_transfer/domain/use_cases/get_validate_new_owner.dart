import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../../features/_shared_feature_/data/models/response_body_model.dart';
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
