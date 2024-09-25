import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import '../../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../entity/apply_request_entity.dart';
import '../entity/permits_response_entity.dart';
import '../entity/transfer_license_request.dart';
import '../entity/validate_license_entity.dart';
import '../entity/validate_owner_entity.dart';

abstract class TransferLicenseRepository {
  Future<Either<Failure, ResponseBodyModel<PermitsResponseEntity>>>
      getLicensePermits(String licenseNumber);

  Future<Either<Failure, ResponseBodyModel<ValidateOwnerEntity>>>
      validateNewOwner(String licenseNumber, String crNumber);

  Future<Either<Failure, ResponseBodyModel<ValidateLicenseEntity>>>
      validateLicense(String licenseNumber);

  Future<Either<Failure, ResponseBodyModel<ApplyRequestEntity>>> sendToNewOwner(
      String licenseNumber, TransferLicenseRequest request);
}
