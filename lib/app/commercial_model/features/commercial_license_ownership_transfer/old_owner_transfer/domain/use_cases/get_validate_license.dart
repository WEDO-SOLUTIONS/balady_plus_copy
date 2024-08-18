import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../entity/validate_license_entity.dart';
import '../repository/repository.dart';

class GetValidateLicense
    extends UseCase<ResponseBodyModel<ValidateLicenseEntity>, (String,)> {
  final TransferLicenseRepository repository;

  GetValidateLicense({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<ValidateLicenseEntity>>> call(
      (String,) params) async {
    return await repository.validateLicense(params.$1);
  }
}
