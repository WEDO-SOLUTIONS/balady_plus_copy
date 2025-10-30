import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/attachment_resposne_model.dart';
import '../../data/models/group_item_response_model.dart';
import '../../data/models/permit_apply_group_response_model.dart';
import '../../data/models/permit_license_response_model.dart';
import '../../data/models/permit_poster_types_response.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../../data/models/permits_alerts_response.dart';
import '../../data/models/poster_request_details_model.dart';
import '../../data/models/posters_upload_response_model.dart';
import '../entities/permit_apply_group_request_params.dart';
import '../entities/permit_licenses_requests_params.dart';
import '../entities/permit_required_types_params.dart';
import '../entities/save_poster_request_params.dart';

abstract class PostersRepository {
  Future<Either<Failure, PermitsLicensesResponse>> getLicensePermits(
      {required PermitLicenseRequestParams params});

  Future<Either<Failure, GroupItemResponseModel>> getGroupItems();

  Future<Either<Failure, dynamic>> savePoster(
      {required SavePosterRequestParams params});

  Future<Either<Failure, AttachmentResponseModel>> getAttachmentTypes(
      {required PermitRequiredTypesParams params});

  Future<Either<Failure, PermitPosterTypeResponse>> getPErmitPosterTypes();

  Future<Either<Failure, PermitApplyGroupResponse>> applyPermitLicenseGroup(
      {required PermitApplyGroupRequestParams params});

  Future<Either<Failure, PostersUploadResponse>> uploadPosterFile(
      {required PermitAttachmentItem params});

  Future<Either<Failure, PostersSubmitResponseModel>> submit(
      {required int params});

  Future<Either<Failure, bool>> addIndivisualRequests({required int params});

  Future<Either<Failure, PosterRequestDetailsModel>> getPosterRequestDetails(
      {required int params});

  Future<Either<Failure, bool>> deleteLicenseFromRequest(
      {required int requestId, required int licenseId});

  Future<Either<Failure, PermitAlertsResponse>> getPermitsAlerts();

  Future<Either<Failure, bool>> deletePermitRequest({required int params});

  Future<Either<Failure, PermitApplyGroupResponse>> applyLicense(
      {required int params});

  Future<Either<Failure, PosterAllowedAction>> getAllowedActionsOnRequest(
      {required int params});
}
