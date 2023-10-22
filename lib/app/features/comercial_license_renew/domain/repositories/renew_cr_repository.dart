import 'package:dartz/dartz.dart';
import '../../../../core/errors/errors_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../renew_commercial_license_exports.dart';
import '../entities/cr_attachment_response.dart';
import '../entities/cr_submit_request.dart';

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

  Future<Either<Failure, CrCalculateFeesResponse>> crCalculateFee(
      {required CrCalculateFeesRequest params});

}
