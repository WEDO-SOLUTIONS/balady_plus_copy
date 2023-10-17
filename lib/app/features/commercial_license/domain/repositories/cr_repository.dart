import 'package:dartz/dartz.dart';
import '../../../../core/errors/errors_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/save_com_submitter_and_owner_request_model.dart';

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
}
