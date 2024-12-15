import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/additional_activity_details_response.dart';
import '../../data/models/additional_activity_response.dart';
import '../../data/models/board_contract_responseModel.dart';
import '../../data/models/citizen_info.dart';
import '../../data/models/commercial_request_details_response_entity.dart';
import '../../data/models/conclusion_response_entity.dart';
import '../../data/models/attachment_response_entity.dart';
import '../../data/models/initialApproval/fees_request.dart';
import '../../data/models/initialApproval/isics_main_activity.dart';
import '../../data/models/initialApproval/request_details_model.dart';
import '../../data/models/qr/submit_commercial_response_model.dart';
import '../../data/models/qr/qr_details.dart';
import '../../data/models/qr/qr_lookup_model.dart';
import '../../data/models/qr/qr_submit_response.dart';
import '../../data/models/qr/save_enterprise_data_request_model.dart';
import '../../data/models/salama_warning_request.dart';
import '../../data/models/initialApproval/save_com_submitter_and_owner_request_model.dart';
import '../../data/models/initialApproval/sub_activity_details_data.dart';
import '../entities/addetional_activity_details_request.dart';
import '../entities/citizen_info_params.dart';
import '../entities/cr_submit_request.dart';
import '../entities/save_shop_details_request.dart';
import '../entities/verifiy_salama_requst.dart';

abstract class Repository {
  Future<Either<Failure, ResponseBodyModel<RequestDetailsModel>>> getInitialApprovalRequestDetails(int requestId);

  Future<Either<Failure, ResponseBodyModel<SubActivityDetailsData>>>
      getSubActivityDetails({required String id});

  Future<Either<Failure, List<SubActivityEntity>>> getSubActivities(int requestID,int isicCode);
  Future<Either<Failure, List<IsicsMainActivity>>> getMainActivities( int requestID);

  Future<Either<Failure, bool>> addIsicActivities(
      {required AddIsicActivityData params});

  Future<Either<Failure, List<LookupsModel>>> getAccommodationTypes();

  Future<Either<Failure, int>> saveComSubmitterAndOwner(
      SubmitterAndOwnerRequestModel? params);

  Future<Either<Failure, int>> saveActivityDetails(
      SubmitActivityDetailRequest? params);

  Future<Either<Failure, SaveLocationResponseModel>> saveLocationDetails(
      SaveLocationDataRequest? params);

  Future<Either<Failure, DeedInfoResponseModel>> getDeedInfo(
      DeedInfoRequest? params);

  Future<Either<Failure, EjarInfoResponseModel>> getEjarInfo(
      EjarInfoRequest? params);
  Future<Either<Failure, CleanContractsResponseEntity>> getCleanContracts(
      CleanContractsRequest? params);
  Future<Either<Failure, InvestmentContractResponseModel>> getInvestmentContracts(
      InvestmentContractRequest? params);

  Future<Either<Failure, AttachmentResponseEntity>> getCRAttachments(int? params);

  Future<Either<Failure, bool>> saveAttachment(
      {required CrAttachmentRequest params});

  Future<Either<Failure, CalculateFeesResponseModel>> crCalculateFee(
      {required CrCalculateFeesRequest params});

  Future<Either<Failure, CalculateFeesResponseModel>> CalculateFeesInteractively(
      {required FeesRequest params});


  Future<Either<Failure, int>> addBeneficiaryNotes(
      {required CrAddNotesRequest params});

  Future<Either<Failure, ResponseBodyModel<SubmitRequestResponseModel>>> submitCr(
      {required CrSubmitRequest params});

  Future<Either<Failure, dynamic>> saveShopDetails(
      {required SaveShopDetailsRequest params});

  Future<Either<Failure, CleanOptionResponseEntity>> getCleanOptions(
      {required int params});
  Future<Either<Failure, List<String>>> getDeedOptions({required int params});

  Future<Either<Failure, CredenceResponseModel>> getRequestCredences(
      {required int params});

  Future<Either<Failure, bool>> uploadCredence(
      {required CrAttachmentRequest params});

  Future<Either<Failure, bool>> validateApprovals({required int params});

  Future<Either<Failure, int>> validateSalamaAttachments(
      {required ValidateSalamaAttachmentsRequest params});

  Future<Either<Failure, bool>> fawrySalamaReport({required int params});

  Future<Either<Failure, bool>> fawrySalamaBills({required int params});

  Future<Either<Failure, SubmitRequestResponseModel>> submitInitialApproval(int requestId);


  Future<Either<Failure, SubmitCommercialResponseModel>> applyCommercialRequest(
      {required int params});

  Future<Either<Failure, QrDetails>> getQrCodeDetails(
      {required int params});

  Future<Either<Failure, int>> saveQrEnterpriseData(
      {required SaveEnterprisDataRequestModel params});

  Future<Either<Failure, int>> saveQrWorkTimesData(
      {required SaveWorkTimesRequestModel params});

  Future<Either<Failure, int>> saveAddetionalQrData(
      {required AdditionalQrDataRequestModel params});

  Future<Either<Failure, AttachmentResponseEntity>> getQrAttachments(
      {required int params});

  Future<Either<Failure, bool>> uploadQrAttachments(
      {required CrAttachmentRequest params});

  Future<Either<Failure, QrSubmitResponse>> qrSubmit({required int params});
  Future<Either<Failure, QrLookUpResponseModel>> getQrLookUp(
      {required String params});

  Future<Either<Failure, QrLookUpResponseModel>> getMalls({required String params});

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

  Future<Either<Failure, BoardContractResponseModel>> getBoardContracts(
      {required int params});

  Future<Either<Failure, CitizenInfo>> getCizenInfo(
      {required CitizenInfoParams params});
  Future<Either<Failure, CommercialRequestDetailsResponseEntity>> getRequestDetails(
      {required int params});

  Future<Either<Failure, IssueCommercialConculsionEntity>> getCommercialConculsion(
      {required int params});
}
