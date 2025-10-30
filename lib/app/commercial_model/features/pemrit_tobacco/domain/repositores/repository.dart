import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/calculate_cost_response_model.dart';
import '../../data/models/permit_request_details_model.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../../data/models/permits_alerts_response.dart';
import '../../data/models/validate_hotel_license.dart';
import '../entities/permit_tobacco_caclualte_request.dart';
import '../entities/submit_tobacco_request.dart';
import '../entities/validate_hotel_license_request.dart';

abstract class PermitsTobaccoRepository {
  Future<Either<Failure, PermitTobaccoAllowedAction>> getPermitAllowedActions(
      {required int params});

  Future<Either<Failure, PermitTobaccoAlertsResponse>> getPermitsAlerts();
  Future<Either<Failure, bool>> validateBeforeApply({required int params});

  Future<Either<Failure, PermitTobaccoSubmitResponseModel>> submit(
      {required SubmitTobaccoRequest params});

  Future<Either<Failure, PermitTobaccoRequestDetailsModel>>
      getPermitRequestDetails({required int params});

  Future<Either<Failure, CalculateCostPermitTobaccoResponse>>
      calculatePermit24HourCost(
          {required PermitTobaccoCalculateRequest params});

  Future<Either<Failure, bool>> deletePermitRequest({required int requestId});

  Future<Either<Failure, PermitTobaccoValidateHotelLicense>>
      validateHotelLicense({required ValidateHotelLicenseRequest params});
}
