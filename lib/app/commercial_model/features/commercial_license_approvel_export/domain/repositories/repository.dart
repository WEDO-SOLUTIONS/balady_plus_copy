import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';

import '../../data/models/initialApproval/conclusion_response_entity.dart';
import '../../data/models/initialApproval/fees_request.dart';
import '../../data/models/initialApproval/isics_main_activity.dart';
import '../../data/models/initialApproval/request_details_model.dart';
import '../../data/models/initialApproval/save_activity_and_location_response_model.dart';
import '../../data/models/initialApproval/save_com_submitter_and_owner_request_model.dart';
import '../../data/models/initialApproval/sub_activity_details_data.dart';


abstract class Repository {
  Future<Either<Failure, ResponseBodyModel<RequestDetailsModel>>> getInitialApprovalRequestDetails(int requestId);
  Future<Either<Failure, ResponseBodyModel<SubActivityDetailsData>>> getSubActivityDetails({required String id});
  Future<Either<Failure, List<SubActivityEntity>>> getSubActivities(int requestID,int isicCode);
  Future<Either<Failure, List<IsicsMainActivity>>> getMainActivities( int requestID);
  Future<Either<Failure, bool>> addIsicActivities({required AddIsicActivityData params});
  Future<Either<Failure, List<LookupsModel>>> getAccommodationTypes();
  Future<Either<Failure, int>> saveComSubmitterAndOwner(SubmitterAndOwnerRequestModel? params);
  Future<Either<Failure, int>> applyLicenseExport(int request);
  Future<Either<Failure, ResponseBodyModel<SaveActivityAndLocationResponseModel>>> saveActivityDetails(SubmitActivityDetailRequest? params);
  Future<Either<Failure, SaveLocationResponseModel>> saveLocationDetails(SaveLocationDataRequest? params);
  Future<Either<Failure, CalculateFeesResponseModel>> crCalculateFee({required CrCalculateFeesRequest params});

  Future<Either<Failure, CalculateFeesResponseModel>> CalculateFeesInteractively({required FeesRequest params});
  Future<Either<Failure, String>> getSPLNotification({required String requestId,required String mencipiltyId});

  Future<Either<Failure, SubmitRequestResponseModel>> submitInitialApproval(int requestId);

  Future<Either<Failure, IssueCommercialConculsionEntity>> getCommercialConculsion({required int params});

  Future<Either<Failure, bool>> cancelIntialApproval({required int params});

  Future<Either<Failure, bool>> ReplyWithNote(String requestId,String note,String noteId);
}
