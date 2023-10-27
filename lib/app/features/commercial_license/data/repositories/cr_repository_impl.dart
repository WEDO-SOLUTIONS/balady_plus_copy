import 'package:balady_plus/app/features/commercial_license/data/models/save_com_submitter_and_owner_request_model.dart';
import 'package:balady_plus/app/features/commercial_license/domain/entities/cr_attachment_response.dart';
import 'package:balady_plus/app/features/commercial_license/domain/entities/cr_submit_request.dart';
import 'package:balady_plus/app/features/commercial_license/domain/entities/save_shop_details_request.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import '../../../../core/errors/errors_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';

class CrRepositoryImpl implements CrRepository {
  final CrRemoteDataSource remoteDataSource;

  CrRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<SubActivityDetails>>>
      getSubActivityDetails({required String id}) async {
    try {
      final data =
          await remoteDataSource.getSubActivityDetails(subActivityId: id);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<RecordInfo>>> getRecordInfo(
      {required String crNumber, required String role}) async {
    try {
      final data =
          await remoteDataSource.getRecordInfo(crNumber: crNumber, role: role);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<SubActivityEntity>>> getSubActivities(
      {required String isicCode}) async {
    try {
      final data = await remoteDataSource.getSubActivities(isicCode: isicCode);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, bool>> addIsicActivities(
      {required AddIsicActivitiesParams params}) async {
    try {
      final data = await remoteDataSource.addIsicActivities(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<CrLookupsEntity>>> getAccommodationTypes() async {
    try {
      final data = await remoteDataSource.getAccommodationTypes();

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, int>> saveComSubmitterAndOwner(
      SaveComSubmitterAndOwnerRequestModel? params) async {
    try {
      final data =
          await remoteDataSource.saveComSubmitterAndOwner(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, int>> saveActivityDetails(
      SubmitActivityDetailRequest? params) async {
    try {
      final data = await remoteDataSource.saveActivityDetails(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, SaveLocationResponseModel>> saveLocationDetails(
      SaveLocationDataRequest? params) async {
    try {
      final data = await remoteDataSource.saveLocationDetails(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, CleanContractsResponse>> getCleanContracts(
      CleanContractsRequest? params) async {
    try {
      final data = await remoteDataSource.getCleanContracts(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, DeedInfoResponse>> getDeedInfo(
      DeedInfoRequest? params) async {
    try {
      final data = await remoteDataSource.getDeedInfo(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, EjarInfoResponse>> getEjarInfo(
      EjarInfoRequest? params) async {
    try {
      final data = await remoteDataSource.getEjarInfo(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, InvestmentContractResponse>> getInvestmentContracts(
      InvestmentContractRequest? params) async {
    try {
      final data =
          await remoteDataSource.getInvestmentContracts(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, CrAttachmentResponse>> getCRAttachments(
      int? params) async {
    try {
      final data = await remoteDataSource.getCRAttachment(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, bool>> saveAttachment(
      {required CrAttachmentRequest params}) async {
    try {
      final data = await remoteDataSource.saveAttachment(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, CrCalculateFeesResponse>> crCalculateFee(
      {required CrCalculateFeesRequest params}) async {
    try {
      final data = await remoteDataSource.crCalculateFees(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, int>> addBeneficiaryNotes(
      {required CrAddNotesRequest params}) async {
    try {
      final data = await remoteDataSource.addBeneficiaryNotes(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, CrSubmitResponse>> submitCr(
      {required CrSubmitRequest params}) async {
    try {
      final data = await remoteDataSource.submitCr(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, dynamic>> saveShopDetails(
      {required SaveShopDetailsRequest params}) async {
    try {
      final data = await remoteDataSource.saveShopDetails(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, CleanOptionResponse>> getCleanOptions(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getCleanOptions(params: params);
      return Right(data!);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getDeedOptions(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getDeedOptions(params: params);
      return Right(data!);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, CredenceInfo>> getRequestCredences(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getRequestCredences(params: params);
      return Right(data!);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadCredence(
      {required CrAttachmentRequest params}) async {
    try {
      final data = await remoteDataSource.uploadCredence(params: params);
      return Right(data!);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, bool>> validateApprovals({required int params}) async {
    try {
      final data = await remoteDataSource.validateApprovals(params: params);
      return Right(data!);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, int>> validateSalamaAttachments(
      {required ValidateSalamaAttachmentsRequest params}) async {
    try {
      final data =
          await remoteDataSource.validateSalamaAttachments(params: params);
      return Right(data!);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }
}
