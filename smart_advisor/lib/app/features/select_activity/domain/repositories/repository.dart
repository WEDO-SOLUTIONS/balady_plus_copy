import 'package:smart_advisor/app/features/select_activity/data/models/work_flow_model.dart';

import '../../../_shared_feature_/presentation/models/lookUp_response_model.dart';
import '../../data/models/activity_details_info.dart';
import '../entities/work_flow_request_params.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/activity_request_params.dart';
import '/app/features/select_activity/domain/entities/categories_request_params.dart';
import '/app/features/select_activity/domain/entities/isics_request_params.dart';
import '/app/features/select_activity/domain/entities/rubrics_request_params.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../entities/addetional_activites_response.dart';
import '../entities/permit_request_params.dart';
import '../entities/permits_activites_response.dart';

abstract class ActivitesRepository {
  Future<Either<Failure, List<AddetionalActivityItem>>> getAddetionalActivites(
      String params);

  Future<Either<Failure, List<PermitItem>>> getPermits(
      PermitRequestParams params);

  Future<Either<Failure, LookUpResponse>> getSectors();

  Future<Either<Failure, List<LookUpItem>>> getcategories(
      CategoriesRequestParams params);

  Future<Either<Failure, List<LookUpItem>>> getRubrics(
      RubricsRequestParams params);

  Future<Either<Failure, List<LookUpItem>>> getIsics(IsicsRequestParams params);

  Future<Either<Failure, List<LookUpItem>>> getActivites(
      ActivityRequestParams params);

  Future<Either<Failure, List<LookUpItem>>> getCities();

  Future<Either<Failure, List<LookUpItem>>> getDistricts(int cityId);

  Future<Either<Failure, List<WorkFlowModel>>> getWorkFlow(
      WorkFlowRequestParams params);

  Future<Either<Failure, ActivityDetailsInfo>> getActivityInfo(int params);
}
