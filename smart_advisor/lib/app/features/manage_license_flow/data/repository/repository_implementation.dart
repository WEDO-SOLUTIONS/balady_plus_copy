import 'package:dartz/dartz.dart';
import 'package:smart_advisor/app/core/errors/exceptions.dart';
import 'package:smart_advisor/app/core/errors/failures.dart';
import 'package:smart_advisor/app/features/manage_license_flow/data/data_sources/remote_data_source.dart';
import 'package:smart_advisor/app/features/manage_license_flow/data/model/license_details_model.dart';
import 'package:smart_advisor/app/features/manage_license_flow/data/model/license_model.dart';
import 'package:smart_advisor/app/features/manage_license_flow/domain/entities/commercial_license_model.dart';
import 'package:smart_advisor/app/features/manage_license_flow/domain/entities/license_request_params.dart';
import 'package:smart_advisor/app/features/manage_license_flow/domain/repositories/repository.dart';

import '../../domain/entities/delegator_entity.dart';

class ManageLicenseImplementationRepository implements ManageLicenseRepository {
  final ManageLicenseDataSource licenseDataSource;
  ManageLicenseImplementationRepository({required this.licenseDataSource});

  @override
  Future<Either<Failure, List<DelegatorEntity>>> getDelegators() async {
    try {
      final data = await licenseDataSource.getDelegators();
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, String>> cancelCommercialLicense(int id) async {
    try {
      final data = await licenseDataSource.cancelCommercialLicense(id);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, String>> issueLicenseCommercial(
      CommercialLicenseModel commercialLicense) async {
    try {
      final data =
          await licenseDataSource.issueCommercialLicense(commercialLicense);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, String>> modifyCommercialLicense(
      int id, CommercialLicenseModel commercialLicense) async {
    try {
      final data = await licenseDataSource.modifyCommercialLicense(
          id, commercialLicense);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, String>> transferOwnershipCommercialLicense(
      int id, CommercialLicenseModel commercialLicense) async {
    try {
      final data = await licenseDataSource.transferOwnershipCommercialLicense(
          id, commercialLicense);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<LicensesResponseItem>>> getLicenses(
      LicenseRequestParams request) async {
    try {
      final data = await licenseDataSource.getLicenses(request);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, LicenseDetails>> getLicenseDetails(
      String licenseNo) async {
    try {
      final data = await licenseDataSource.getLicenseDetails(licenseNo);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, String>> renewCommercialLicense(int id) async {
    try {
      final data = await licenseDataSource.renewCommercialLicense(id);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }
}
