import 'package:dartz/dartz.dart';
import '../../../../core/errors/errors_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/save_com_submitter_and_owner_request_model.dart';
import '../entities/cr_attachment_response.dart';
import '../entities/cr_submit_request.dart';
import '../entities/save_shop_details_request.dart';

abstract class CrRepository {
  Future<Either<Failure, ResponseBodyModel<RecordInfo>>> getRecordInfo(
      {required String crNumber, required String role});

  Future<Either<Failure, ResponseBodyModel<SubActivityDetails>>>
      getSubActivityDetails({required String id});

  Future<Either<Failure, List<SubActivityEntity>>> getSubActivities(
      {required String isicCode});

  Future<Either<Failure, bool>> addIsicActivities(
      {required AddIsicActivitiesParams params});

  Future<Either<Failure, List<CrLookupsEntity>>> getAccommodationTypes();

  Future<Either<Failure, int>> saveComSubmitterAndOwner(
      SaveComSubmitterAndOwnerRequestModel? params);

  Future<Either<Failure, int>> saveActivityDetails(
      SubmitActivityDetailRequest? params);

  Future<Either<Failure, SaveLocationResponseModel>> saveLocationDetails(
      SaveLocationDataRequest? params);

  Future<Either<Failure, DeedInfoResponse>> getDeedInfo(
      DeedInfoRequest? params);

  Future<Either<Failure, EjarInfoResponse>> getEjarInfo(
      EjarInfoRequest? params);
  Future<Either<Failure, CleanContractsResponse>> getCleanContracts(
      CleanContractsRequest? params);
  Future<Either<Failure, InvestmentContractResponse>> getInvestmentContracts(
      InvestmentContractRequest? params);

  Future<Either<Failure, CrAttachmentResponse>> getCRAttachments(int? params);

  Future<Either<Failure, bool>> saveAttachment(
      {required CrAttachmentRequest params});

  Future<Either<Failure, CrCalculateFeesResponse>> crCalculateFee(
      {required CrCalculateFeesRequest params});

  Future<Either<Failure, int>> addBeneficiaryNotes(
      {required CrAddNotesRequest params});

  Future<Either<Failure, CrSubmitResponse>> submitCr(
      {required CrSubmitRequest params});

  Future<Either<Failure, dynamic>> saveShopDetails(
      {required SaveShopDetailsRequest params});

  Future<Either<Failure, CleanOptionResponse>> getCleanOptions(
      {required int params});
  Future<Either<Failure, List<String>>> getDeedOptions({required int params});

  Future<Either<Failure, CredenceInfo>> getRequestCredences(
      {required int params});

  Future<Either<Failure, bool>> uploadCredence(
      {required CrAttachmentRequest params});

  Future<Either<Failure, bool>> validateApprovals({required int params});

  Future<Either<Failure, int>> validateSalamaAttachments(
      {required ValidateSalamaAttachmentsRequest params});


  Future<Either<Failure, bool>> fawrySalamaReport(
      {required int params});


  Future<Either<Failure, bool>> fawrySalamaBills(
      {required int params});
}
