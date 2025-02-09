import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/ekram/data/data_sources/ekram_remote_data_source.dart';
import 'package:balady_plus/app/features/ekram/data/model/add_trip_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/apply_deceased/apply_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/apply_deceased/grave_active_request_details.dart';
import 'package:balady_plus/app/features/ekram/data/model/baqie_approval_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/deceased_transport_requests/transport_request_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_attachment_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_transport_validate_submit_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/look_up_item_location_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/madinah_emirate_approval_status.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/request_details_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/save_death_burial_info_params/save_death_burial_info_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/transportation_companies_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/user_info_response_model/user_info_response_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/active_grave_request_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/apply_deceased_response.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_request_details/deceased_request_details.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/get_orgnizations_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_location_response.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/ekram/domain/repositories/ekram_repository.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../domain/entities/book_cemetry_params.dart';
import '../../domain/entities/cemetry_request_details/cemetry_request_details.dart';
import '../../domain/entities/cemetry_requests/cemetry_request_response.dart';
import '../../domain/entities/get_cemetries_params.dart';
import '../../domain/entities/user_info_request_params.dart';
import '../model/cemetries_params.dart';
import '../model/driver/EditAdditionalRequest.dart';
import '../model/driver/GhuslEmploye.dart';
import '../model/driver/deceased_attachment.dart';
import '../model/driver/deceased_identical_item.dart';
import '../model/driver/transport_request_item_model.dart';
import '../model/driver/trip_details_model.dart';
import '../model/driver/trip_stations.dart';
import '../model/mosque_ghusl_places_params.dart';
import '../model/request_details_response_model/SaveDeceasedInfoParams.dart';
import '../model/upload_letter_params.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class EkramRepositoryImpl implements EkramRepository {
  final EkramRemoteDataSource remoteDataSource;

  EkramRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getCountries() async {
    try {
      final data = await remoteDataSource.getCountries();

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getCities() async {
    try {
      final data = await remoteDataSource.getCities();

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getHospitals(
      int cityId) async {
    try {
      final data = await remoteDataSource.getHospitals(cityId);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getNationalities(int? identityTypeId) async {
    try {
      final data = await remoteDataSource.getNationalities(identityTypeId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getPrayers() async {
    try {
      final data = await remoteDataSource.getPrayers();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<ApplyDeceasedResponse>>>
      applyDeceasedTransport(ApplyDeceasedParams params) async {
    try {
      final data = await remoteDataSource.applyDeceasedTransport(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
  @override
   Future<Either<Failure,ResponseBodyModel<MadinahEmirateApprovalStatusResponseModel>>>
      madinahEmirateApprovalStatus(int cemetryId, int id, int idType)  async {
    try {
      final data = await remoteDataSource.madinahEmirateApprovalStatus(cemetryId,id,idType);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getLookUp(
      int id) async {
    try {
      final data = await remoteDataSource.getLookup(id);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<TransportRequestResponseModel>>>
      getDeceasedTransportRequests(GetRequestsParams params) async {
    try {
      final data = await remoteDataSource.getDeceasedTransportRequests(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>>
      getDeceasedTransportRequestDetails(int params) async {
    try {
      final data = await remoteDataSource.getTransportRequestDetails(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<DeceasedIdenticalItem>>>>
      getidenticalList(int params) async {
    try {
      final data = await remoteDataSource.getIdenticalList(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<TripDetailsModel>>>> getTrips(
      int params) async {
    try {
      final data = await remoteDataSource.getTrips(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> addTrip(
      int requestId, TripDetailsModel params) async {
    try {
      final data = await remoteDataSource.addTrip(requestId, params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> editTrip(
      int requestID, TripDetailsModel model) async {
    try {
      final data = await remoteDataSource.editTrip(requestID, model);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getCemetriesLookUp(int requestId, CemetriesParams params) async {
    try {
      final data = await remoteDataSource.getCemetriesLookUp(requestId, params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>>
      getMosquesLookUp(int transportId,List<int?> cityIds, MosqueGhuslPlacesParams params) async {
    try {
      final data = await remoteDataSource.getMosquesLookUp(transportId,cityIds, params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>>
      getLaundriesLookup(int transportId,List<int?> cityIds, MosqueGhuslPlacesParams params) async {
    try {
      final data = await remoteDataSource.getLaundriesLookUp(transportId,cityIds, params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> completeTrip(
      int params) async {
    try {
      final data = await remoteDataSource.completeTrip(params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> deleteTrip(
      int tripId, int requestId) async {
    try {
      final data = await remoteDataSource.deleteTrip(tripId, requestId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> deleteAttachment(
      int attachmentId, int requestId) async {
    try {
      final data =
          await remoteDataSource.deleteAttachment(attachmentId, requestId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedAttachment>>>
      uploadAttachment(int attachmentId, FileDataItem params) async {
    try {
      final data =
          await remoteDataSource.uploadAttachment(attachmentId, params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> upadateDriverLocation(
      UpdateDriverLocationParams params) async {
    try {
      final data = await remoteDataSource.upadateDriverLocation(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
  @override
  Future<Either<Failure, ResponseBodyModel>> currentTrackLocation(
      int requestId) async {
    try {
      final data = await remoteDataSource.currentTrackLocation(requestId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<TripLocationsResponse>>>
      getTripsLocation(int params) async {
    try {
      final data = await remoteDataSource.getTripsLocation(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getLocations() async {
    try {
      final data = await remoteDataSource.getLocations();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getStatus() async {
    try {
      final data = await remoteDataSource.getStatus();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> editAdditionalData(
      EditAdditionalRequest request) async {
    try {
      final data = await remoteDataSource.editAdditionalData(
          request.requestId!, request);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getEkramLookUp(
      String id) async {
    try {
      final data = await remoteDataSource.getEkramLookup(id);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<UserInfoResponseModel>>>
      checkUserinfo(UserInfoRequestParams params) async {
    try {
      final data = await remoteDataSource.checkUserinfo(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getActiveCities() async {
    try {
      final data = await remoteDataSource.getActiveCities();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getCemetries(
      GetCemetriesParams params) async {
    try {
      final data = await remoteDataSource.getCemetries(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<GhuslEmploye>>>>
      getGhuslEmployees(int requestId) async {
    try {
      final data = await remoteDataSource.getGhuslEmployees(requestId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<DeceasedAttachment>>>>
      getDeceasedAttachment(int requestId) async {
    try {
      final data = await remoteDataSource.getDeceasedAttachment(requestId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<ApplyDeceasedResponse>>> bookCemetry(
      BookCemetryParamas params) async {
    try {
      final data = await remoteDataSource.bookCemetry(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<CemetryRequestDetails>>>
      getCemetryRequestDetails(String params) async {
    try {
      final data = await remoteDataSource.getCemetryRequestDetails(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<CemetryRequestResponse>>>
      getCemetryRequests(GetRequestsParams params) async {
    try {
      final data = await remoteDataSource.getCemetryRequests(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getNationalityTypes() async {
    try {
      final data = await remoteDataSource.getNationalityTypes();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getDeathCities() async {
    try {
      final data = await remoteDataSource.getDeathCities();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getBurialCities() async {
    try {
      final data = await remoteDataSource.getBurialCities();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getEkramOrgnizations(GetOrgnizationsParams params) async {
    try {
      final data = await remoteDataSource.getEkramOrgnizations(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<GraveActiveRequestDetails>>>
      getActiveGraveRequestDetails(ActiveGraveRequestParams params) async {
    try {
      final data = await remoteDataSource.getActiveGraveRequestDetails(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, BaqieApprovalResponse>> baqieApproval(
      ActiveGraveRequestParams params) async {
    try {
      final data = await remoteDataSource.baqieApproval(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<TripStations>>>>
      getTripStations(int params) async {
    try {
      final data = await remoteDataSource.getTripStations(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> verifyDeceased(
      VerifyDeceasedParams params) async {
    try {
      final data = await remoteDataSource.verifyDeceased(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<RequestDetailsResponseModel>>>
      requestDetails(int requestId) async {
    try {
      final data = await remoteDataSource.requestDetails(requestId);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> saveDeathBurialInfo(
      int requestId, SaveDeathBurialInfoParams params) async {
    try {
      final data =
          await remoteDataSource.saveDeathBurialInfo(requestId, params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }
  @override
  Future<Either<Failure, ResponseBodyModel>> ekramTransportValidateSubmit(
      int requestId , EkramTransportValidateSubmitParams params) async {
    try {
      final data =
          await remoteDataSource.ekramTransportValidateSubmit(requestId,params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> saveDeceasedInfo(
      int requestId, SaveDeceasedInfoParams params) async {
    try {
      final data = await remoteDataSource.saveDeceasedInfo(requestId, params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getCemeteryTypesLookUp() async {
    try {
      final data = await remoteDataSource.getCemeteryTypesLookUp();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getSpecialTransportReasonsLookUp() async {
    try {
      final data = await remoteDataSource.getSpecialTransportReasonsLookUp();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getTransportationCompaniesLookUp(int requestId , TransportationCompaniesParams params) async {
    try {
      final data = await remoteDataSource.getTransportationCompaniesLookUp( requestId, params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }



}
