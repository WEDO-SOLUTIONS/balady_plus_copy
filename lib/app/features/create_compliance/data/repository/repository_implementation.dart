import 'package:balady_plus/app/features/create_compliance/data/models/apply_create_compliance_request_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/compliance_certificate_items_request.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/compliance_engoffice_details_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/complinace_engoffice_response_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/complinace_licenses_response_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/ownership_doc_type_response_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/save_contract_info_request.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/save_location_compliance_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/apply_create_compliance_response.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/comliance_request_details.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/compliance_attachment_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/compliance_gis_resopnse.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/send_otp_response.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/verify_otp_request.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/repository.dart';
import '../datasource/create_compliance_remote_data_source.dart';

class CreateComplianceRepositoryImplementation
    implements CreateComplianceRepository {
  final CreateComplianceRemoteDataSource remoteDataSource;

  CreateComplianceRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ApplyCreateComplianceResponse>> applyCreateCompliance(
      ApplyCreateComplianceRequest params) async {
    try {
      final data = await remoteDataSource.applyCreateCompliance(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplianceRequestDetails>> getComplianceByRequestId(
      String params) async {
    try {
      final data = await remoteDataSource.getComplianceByRequestId(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveLocationCompliance(
      SaveLocationComplianceRequest params) async {
    try {
      final data = await remoteDataSource.saveLocationCompliance(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplianceEngOfficeDetailsModel>>
      getComplianceEngOfficeDetails({required String id}) async {
    try {
      final data = await remoteDataSource.getComplianceEngOfficeDetails(id: id);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplinaecEngOfficeReponseModel>>
      getComplianceEngOffices() async {
    try {
      final data = await remoteDataSource.getComplianceEngOffices();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplinaecLicensesReponseModel>>
      getComplianceLicense() async {
    try {
      final data = await remoteDataSource.getComplianceLicense();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplinaceLookUpResponseModel>> getMainUsages() async {
    try {
      final data = await remoteDataSource.getMainUsages();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplinaceLookUpResponseModel>>
      getOwnerShipDocTypeResponse() async {
    try {
      final data = await remoteDataSource.getOwnerShipDocTypeResponse();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplinaceLookUpResponseModel>> getSubUsages(
      {required int mainId}) async {
    try {
      final data = await remoteDataSource.getSubUsages(mainId: mainId);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveComplianceCertificateItems(
      ComplianceCertificateItemsRequest params) async {
    try {
      final data =
          await remoteDataSource.saveComplianceCertificateItems(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveContractInfo(
      SaveContractInfoRequest params) async {
    try {
      final data = await remoteDataSource.saveContractInfo(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> submitRequest(String params) async {
    try {
      final data = await remoteDataSource.submitRequest(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplainceGISResponse>> getGISInfo(
      {required GISParams params}) async {
    try {
      final data = await remoteDataSource.getGISInfo(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveAttachment(
      {required ComplinaceAttachmentRequest params}) async {
    try {
      final data = await remoteDataSource.saveAttachment(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, SendOtpResponse>> sendOTP(
      {required String params}) async {
    try {
      final data = await remoteDataSource.sendOTP(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOTP(
      {required VerifyOTPRequest params}) async {
    try {
      final data = await remoteDataSource.verifyOTP(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
