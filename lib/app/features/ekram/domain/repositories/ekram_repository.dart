import 'package:balady_plus/app/features/ekram/data/model/user_info_response_model/user_info_response_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_location_response.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/apply_deceased/grave_active_request_details.dart';
import '../../data/model/baqie_approval_response.dart';
import '../../data/model/ekram_attachment_response.dart';
import '../../data/model/look_up_item_location_model.dart';
import '../../data/model/upload_letter_params.dart';
import '../../ekram_exports.dart';
import '../entities/active_grave_request_params.dart';
import '../entities/book_cemetry_params.dart';
import '../entities/cemetry_request_details/cemetry_request_details.dart';
import '../entities/cemetry_requests/cemetry_request_response.dart';
import '../entities/deceased_transport_requests/get_orgnizations_params.dart';
import '../entities/get_cemetries_params.dart';
import '../entities/user_info_request_params.dart';

abstract class EkramRepository {
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getCities();
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getDeathCities();

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getBurialCities();

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getNationalities();
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getHospitals(
      int cityId);
  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>>
      getLaundries(int cityId);

  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>>
      getMosques(int cityId);

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getLookUp(
      int id);
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getEkramLookUp(
      String id);

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getNationalityTypes();

  Future<Either<Failure, ResponseBodyModel<ApplyDeceasedResponse>>>
      applyDeceasedTransport(ApplyDeceasedParams params);

  Future<Either<Failure, ResponseBodyModel<TransportRequestResponseModel>>>
      getDeceasedTransportRequests(GetRequestsParams params);

  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>>
      getDeceasedTransportRequestDetails(int params);
  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>>
      getDeceasedDriverRequestDetails(int params);

  Future<Either<Failure, ResponseBodyModel<List<TripDetails>>>> getTrips(
      int params);

  Future<Either<Failure, ResponseBodyModel<TripLocationsResponse>>>
      getTripsLocation(int params);

  Future<Either<Failure, ResponseBodyModel<dynamic>>> addTrip(
      AddTripParams params);

  Future<Either<Failure, ResponseBodyModel<dynamic>>> deleteTrip(int params);
  Future<Either<Failure, ResponseBodyModel<dynamic>>> completeTrip(int params);

  Future<Either<Failure, ResponseBodyModel<dynamic>>> uploadLetter(
      UploadLetterParamas params);

  Future<Either<Failure, ResponseBodyModel<dynamic>>> upadateDriverLocation(
      UpdateDriverLocationParams params);

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getStatus();
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getLocations();
  Future<Either<Failure, EkramAttachmentResponse>> downLoadAttachment(int id);

  Future<Either<Failure, ResponseBodyModel<UserInfoResponseModel>>>
      checkUserinfo(UserInfoRequestParams params);

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getActiveCities();

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getCemetries(
      GetCemetriesParams params);

  Future<Either<Failure, ResponseBodyModel<ApplyDeceasedResponse>>> bookCemetry(
      BookCemetryParamas params);

  Future<Either<Failure, ResponseBodyModel<CemetryRequestResponse>>>
      getCemetryRequests(GetRequestsParams params);

  Future<Either<Failure, ResponseBodyModel<CemetryRequestDetails>>>
      getCemetryRequestDetails(String params);

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getCountries();

  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getEkramOrgnizations(GetOrgnizationsParams params);

  Future<Either<Failure, ResponseBodyModel<GraveActiveRequestDetails>>>
      getActiveGraveRequestDetails(ActiveGraveRequestParams params);

  Future<Either<Failure, BaqieApprovalResponse>> baqieApproval(
      ActiveGraveRequestParams params);
}
