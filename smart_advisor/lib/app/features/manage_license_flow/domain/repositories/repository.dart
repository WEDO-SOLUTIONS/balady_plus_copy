import 'package:smart_advisor/app/features/manage_license_flow/domain/entities/commercial_license_model.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/model/license_details_model.dart';
import '../../data/model/license_model.dart';
import '../entities/delegator_entity.dart';
import '../entities/license_request_params.dart';

abstract class ManageLicenseRepository {
  Future<Either<Failure, String>> issueLicenseCommercial(
      CommercialLicenseModel commercialLicenseModel);

  Future<Either<Failure, String>> cancelCommercialLicense(int id);

  Future<Either<Failure, String>> renewCommercialLicense(int id);

  Future<Either<Failure, String>> modifyCommercialLicense(
      int id, CommercialLicenseModel commercialLicenseModel);

  Future<Either<Failure, String>> transferOwnershipCommercialLicense(
      int id, CommercialLicenseModel commercialLicenseModel);

  Future<Either<Failure, List<DelegatorEntity>>> getDelegators();

  Future<Either<Failure, List<LicensesResponseItem>>> getLicenses(
      LicenseRequestParams request);

  Future<Either<Failure, LicenseDetails>> getLicenseDetails(String licenseNo);
}
