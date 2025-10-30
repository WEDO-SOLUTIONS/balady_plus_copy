import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/additional_activity_details_response.dart';
import '../../data/models/additional_activity_response.dart';
import '../../data/models/board_contract_response.dart';
import '../../data/models/citizen_info_model.dart';
import '../../data/models/commercial_request_details_response.dart';
import '../../data/models/conclusion_response_model.dart';
import '../../data/models/cr_attachment_response_model.dart';
import '../../data/models/qr/apply_commercial_response_model.dart';
import '../../data/models/qr/qr_details_model.dart';
import '../../data/models/qr/qr_lookup.dart';
import '../../data/models/qr/qr_submit_response.dart';
import '../../data/models/qr/save_enterprise_data_request.dart';
import '../../data/models/salama_warning_request.dart';
import '../../data/models/save_com_submitter_and_owner_request_model.dart';
import '../entities/addetional_activity_details_request.dart';
import '../entities/citizen_info_params.dart';
import '../entities/cr_attachment_response.dart';
import '../entities/cr_submit_request.dart';
import '../entities/save_shop_details_request.dart';
import '../entities/verifiy_salama_requst.dart';

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

  Future<Either<Failure, ResponseBodyModel<CrSubmitResponse>>> submitCr(
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

  Future<Either<Failure, bool>> fawrySalamaReport({required int params});

  Future<Either<Failure, bool>> fawrySalamaBills({required int params});

  Future<Either<Failure, AddetionalActivityResponse>> getAddetionalActivites(
      {final String subActivityId});
  Future<Either<Failure, AddetionalActivityDetailsResponse>>
      getAddetionalDetailsActivites(
          {final AddetionalActivityDetailsRequest params});

  Future<Either<Failure, ApplyCommercialResponseModel>> applyCommercialRequest(
      {required int params});

  Future<Either<Failure, QrDetailsModel>> getQrCodeDetails(
      {required int params});

  Future<Either<Failure, int>> saveQrEnterpriseData(
      {required SaveEnterprisDataRequest params});

  Future<Either<Failure, int>> saveQrWorkTimesData(
      {required SaveWorkTimesRequest params});

  Future<Either<Failure, int>> saveAddetionalQrData(
      {required AddtionalQrDataRequest params});

  Future<Either<Failure, CrAttachmentResponseModel>> getQrAttachments(
      {required int params});

  Future<Either<Failure, bool>> uploadQrAttachments(
      {required CrAttachmentRequest params});

  Future<Either<Failure, QrSubmitResponse>> qrSubmit({required int params});
  Future<Either<Failure, QrLookUpResponse>> getQrLookUp(
      {required String params});

  Future<Either<Failure, QrLookUpResponse>> getMalls({required String params});

  Future<Either<Failure, dynamic>> validateSalamaReport(
      {required VerifySalamaRequest params});
  Future<Either<Failure, dynamic>> validateSalamaBill(
      {required VerifySalamaRequest params});
  Future<Either<Failure, dynamic>> validateSalamaPermit(
      {required VerifySalamaRequest params});

  Future<Either<Failure, String>> getWarningMessage(
      {required SalamaWarningRequest params});

  Future<Either<Failure, String>> getWarningWorkFlowMessage(
      {required SalamaWarningRequest params});

  Future<Either<Failure, BoardContractResponse>> getBoardContracts(
      {required int params});

  Future<Either<Failure, CitizenInfoModel>> getCizenInfo(
      {required CitizenInfoParams params});
  Future<Either<Failure, CommercialRequestDetailsResponse>> getRequestDetails(
      {required int params});

  Future<Either<Failure, IssueCommercialConculsion>> getCommercialConculsion(
      {required int params});
}
