import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license/data/models/cr_submit_response_model.dart';
import '../../data/models/renew_request_details.dart';
import '../../renew_commercial_license_exports.dart';
import '../entities/cr_attachment_response.dart';
import '../entities/save_renew_request.dart';

abstract class RenewCrRepository {
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
  Future<Either<Failure, dynamic>> submitRenewAttachments(
      {required int? params});

  Future<Either<Failure, RenewRequestDetails>> getRequestDetails(
      {required int params});

  Future<Either<Failure, ResponseBodyModel<bool>>> validateRenewBeforeApply(
      {required int? params});

  Future<Either<Failure, ResponseBodyModel<int>>> renewApply(
      {required RenewApplyRequest? params});

  Future<Either<Failure, ResponseBodyModel<List<int>>>> getRenewYears(
      {required int? params});

  Future<Either<Failure, RenewRequestInfo>> calculateRequestInfo(
      {required RenewInfoRequest? params});

  Future<Either<Failure, ResponseBodyModel<dynamic>>> saveRenewRequestInfo(
      {required SaveRenewRequest? params});

  Future<Either<Failure, ResponseBodyModel<CrSubmitResponseModel>>> submitRenew(
      {required int params});
}
