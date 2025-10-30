import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/calculate_cost_response_model.dart';
import '../../data/models/permit_request_details_model.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../../data/models/permits_alerts_response.dart';

abstract class Permits24Repository {
  Future<Either<Failure, Permit24AllowedAction>> getPermitAllowedActions(
      {required int params});

  Future<Either<Failure, PermitAlertsResponse>> getPermitsAlerts(String type);
  Future<Either<Failure, bool>> validateBeforeApply({required int params});

  Future<Either<Failure, PermitSubmitResponseModel>> submit(
      {required int params});

  Future<Either<Failure, Permit24RequestDetailsModel>> getPermitRequestDetails(
      {required int params});

  Future<Either<Failure, CalculateCost24PermitResponse>>
      calculatePermit24HourCost({required int params});

  Future<Either<Failure, bool>> deletePermitRequest({required int requestId});
}
