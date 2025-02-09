import 'dart:convert';

import 'package:balady_plus/app/commercial_model/features/commercial_license/data/data_sources/cr_remote_data_source.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/ekram/data/model/baqie_approval_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/deceased_request_details_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_transport_validate_submit_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/look_up_item_location_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/driver/trip_details_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/madinah_emirate_approval_status.dart';
import 'package:balady_plus/app/features/ekram/data/model/mosque_ghusl_places_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/request_details_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/save_death_burial_info_params/save_death_burial_info_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/transportation_companies_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/trip_location_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/user_info_response_model/user_info_response_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:mime/mime.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../domain/entities/active_grave_request_params.dart';
import '../../domain/entities/book_cemetry_params.dart';
import '../../domain/entities/deceased_transport_requests/get_orgnizations_params.dart';
import '../../domain/entities/get_cemetries_params.dart';
import '../../domain/entities/user_info_request_params.dart';
import '../model/apply_deceased/grave_active_request_details.dart';
import '../model/cemetry_request_details/cemetry_request_details_model.dart';
import '../model/cemetry_requests/cemetry_request_response_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../model/driver/EditAdditionalRequest.dart';
import '../model/driver/GhuslEmploye.dart';
import '../model/driver/deceased_attachment.dart';
import '../model/driver/deceased_identical_item.dart';
import '../model/driver/trip_stations.dart';
import '../model/request_details_response_model/SaveDeceasedInfoParams.dart';

abstract class EkramRemoteDataSource {
  Future<ResponseBodyModel<List<LookUpItem>>> getCities();

  Future<ResponseBodyModel<List<LookUpItem>>> getDeathCities();

  Future<ResponseBodyModel<List<LookUpItem>>> getHospitals(int cityId);

  Future<ResponseBodyModel<List<LookUpItem>>> getNationalities(int? identityTypeId);

  Future<ResponseBodyModel<List<LookUpItem>>> getLookup(int params);

  Future<ResponseBodyModel<ApplyDeceasedResponseModel>> applyDeceasedTransport(
      ApplyDeceasedParams params);

  Future<ResponseBodyModel<TransportRequestResponseModel>>
      getDeceasedTransportRequests(GetRequestsParams params);

  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getTransportRequestDetails(int params);

  Future<ResponseBodyModel<List<DeceasedIdenticalItem>>> getIdenticalList(
      int params);

  Future<ResponseBodyModel<List<TripDetailsModel>>> getTrips(int params);

  Future<ResponseBodyModel> addTrip(int requestId, TripDetailsModel params);

  Future<ResponseBodyModel> editTrip(int requestID, TripDetailsModel params);

  Future<ResponseBodyModel<dynamic>> completeTrip(int params);

  Future<ResponseBodyModel<dynamic>> deleteTrip(int tripId, int requestId);
  Future<ResponseBodyModel<dynamic>> deleteAttachment(
      int attachmentId, int requestId);

  Future<ResponseBodyModel<DeceasedAttachment>> uploadAttachment(
      int attachmentId, FileDataItem params);

  Future<ResponseBodyModel<dynamic>> upadateDriverLocation(
      UpdateDriverLocationParams params);
  Future<ResponseBodyModel<dynamic>> currentTrackLocation(int requestId);

  Future<ResponseBodyModel<TripLocationsResponseModel>> getTripsLocation(
      int params);

  Future<ResponseBodyModel<List<LookUpItem>>> getStatus();

  Future<ResponseBodyModel<List<LookUpItem>>> getLocations();

  Future<ResponseBodyModel<dynamic>> editAdditionalData(
      int id, EditAdditionalRequest request);

  Future<ResponseBodyModel<List<LookUpItem>>> getEkramLookup(String params);

  Future<ResponseBodyModel<UserInfoResponseModel>> checkUserinfo(
      UserInfoRequestParams params);

  Future<ResponseBodyModel<List<LookUpItem>>> getActiveCities();

  Future<ResponseBodyModel<List<GhuslEmploye>>> getGhuslEmployees(
      int requestId);
  Future<ResponseBodyModel<List<DeceasedAttachment>>> getDeceasedAttachment(
      int requestId);

  Future<ResponseBodyModel<ApplyDeceasedResponseModel>> bookCemetry(
      BookCemetryParamas params);

  Future<ResponseBodyModel<CemetryRequestResponseModel>> getCemetryRequests(
      GetRequestsParams params);

  Future<ResponseBodyModel<CemetryRequestDetailsModel>>
      getCemetryRequestDetails(String params);

  Future<ResponseBodyModel<List<LookUpItem>>> getNationalityTypes();

  Future<ResponseBodyModel<List<LookUpItem>>> getCountries();

  Future<ResponseBodyModel<List<LookUpItem>>> getBurialCities();

  Future<ResponseBodyModel<List<LookUpItem>>> getEkramOrgnizations(
      GetOrgnizationsParams params);

  Future<ResponseBodyModel<List<TripStations>>> getTripStations(int params);

  Future<ResponseBodyModel<GraveActiveRequestDetails>>
      getActiveGraveRequestDetails(ActiveGraveRequestParams params);
  Future<ResponseBodyModel<List<LookUpItem>>> getCemetries(
      GetCemetriesParams params);

  Future<BaqieApprovalResponse> baqieApproval(ActiveGraveRequestParams params);

  Future<ResponseBodyModel<List<LookUpItem>>> getPrayers();
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getMosquesLookUp(
      int transportationId, List<int?> cityIds, MosqueGhuslPlacesParams params);
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getLaundriesLookUp(
      int transportationId, List<int?> cityIds, MosqueGhuslPlacesParams params);
  Future<ResponseBodyModel<List<LookUpItem>>>
      getSpecialTransportReasonsLookUp();
  Future<ResponseBodyModel<List<LookUpItem>>> getCemeteryTypesLookUp();
  Future<ResponseBodyModel<List<LookUpItem>>> getCemetriesLookUp(
      int requestId, CemetriesParams params);
  Future<ResponseBodyModel<List<LookUpItem>>> getTransportationCompaniesLookUp(
      int requestId, TransportationCompaniesParams params);
  Future<ResponseBodyModel> verifyDeceased(VerifyDeceasedParams params);
  Future<ResponseBodyModel<RequestDetailsResponseModel>> requestDetails(
      int requestId);
  Future<ResponseBodyModel> saveDeceasedInfo(
      int requestId, SaveDeceasedInfoParams params);
  Future<ResponseBodyModel> saveDeathBurialInfo(
      int requestId, SaveDeathBurialInfoParams params);

  Future<ResponseBodyModel<MadinahEmirateApprovalStatusResponseModel>>
      madinahEmirateApprovalStatus(int cemetryId, int id, int idType);
  Future<ResponseBodyModel> ekramTransportValidateSubmit(
      int requestId, EkramTransportValidateSubmitParams params);
}

class EkramRemoteDataSourceImpl extends EkramRemoteDataSource {
  final WebService webService;

  EkramRemoteDataSourceImpl({required this.webService});

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getCemetries(
      GetCemetriesParams params) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramCemetries,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getNationalities(int? identityTypeId) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramNationalities,
        queryParameters: identityTypeId != null ? {'identityTypeId':identityTypeId} : null
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getCities() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramCities,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<GhuslEmploye>>> getGhuslEmployees(
      int requestId) async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.ghuslEmployees(requestId),
          queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      List<GhuslEmploye> parsedResult = data != null
          ? List<GhuslEmploye>.from(data.map((x) => GhuslEmploye.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<GhuslEmploye>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<DeceasedAttachment>>> getDeceasedAttachment(
      int requestId) async {
    Response response;

    try {
      response = await webService.dio.get(
          ApiUrl.getDeceasedAttachment(requestId),
          queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      List<DeceasedAttachment> parsedResult = data != null
          ? List<DeceasedAttachment>.from(
              data.map((x) => DeceasedAttachment.fromJson(x)))
          : [];

      final decodedResponse =
          ResponseBodyModel<List<DeceasedAttachment>>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getHospitals(int cityId) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramHospitals(cityId),
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<ApplyDeceasedResponseModel>> applyDeceasedTransport(
      ApplyDeceasedParams params) async {
    Response response;

    try {
      print(params.toMap());
      response = await webService.dio.post(
        ApiUrl.ekramDeceasedTransportApply,
        data: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      ApplyDeceasedResponseModel? parsedResult =
          data != null ? ApplyDeceasedResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<ApplyDeceasedResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getLookup(int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramAnotherLookup}/$params",
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<TransportRequestResponseModel>>
      getDeceasedTransportRequests(GetRequestsParams params) async {
    Response response;

    try {
      response = await webService.dio.post(
        ApiUrl.deceasedTransportRequests,
        queryParameters: {
          "page": params.page,
          "size": params.size,
          "isDriver": params.isDriver ?? false,
          // if (int.tryParse(params.text ?? "") != null) "requestId": params.text,
          // if ((params.text?.isNotEmpty ?? false) &&
          //     int.tryParse(params.text ?? "") == null)
          //   "deceasedName": params.text,
          // if ((params.deceasedTransportRequestStatusId != null))
          //   "requestStatusId": params.deceasedTransportRequestStatusId,
          // if ((params.transportLocationStatusId != null))
          //   "transportLocationStatusId": params.transportLocationStatusId,
          // if ((params.isMultiCity != null)) "isMultiCity": params.isMultiCity,
        },
      );
      // String qa = "";
      //
      // qa = await rootBundle.loadString("assets/request.json");
      //
      // var response = json.decode(qa);
      //
      //
      // var data = response["data"]?["result"];
      //

      var data = response.data["data"]?["result"];
      TransportRequestResponseModel? parsedResult =
          data != null ? TransportRequestResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<TransportRequestResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<TripStations>>> getTripStations(
      int params) async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.GetTripstations(params),
          queryParameters: {"isDriver": true});
      var data = response.data["data"]?["result"];

      List<TripStations> parsedResult = data != null
          ? List<TripStations>.from(data.map((x) => TripStations.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<TripStations>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getTransportRequestDetails(int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.deceasedTransportRequestDetails}/$params",
        queryParameters: {"isDriver": 0},
      );

      var data = response.data["data"]?["result"];
      print(data);
      DeceasedRequestDetailsModel? parsedResult =
          data != null ? DeceasedRequestDetailsModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<DeceasedRequestDetailsModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<DeceasedIdenticalItem>>> getIdenticalList(
      int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.getIdenticalDeseasedList("$params")}",
        queryParameters: {"transportActions": "ADD_TRIP"},
      );

      var data = response.data["data"]?["result"];

      // DeceasedRequestDetailsModel? parsedResult =
      //     data != null ? DeceasedRequestDetailsModel.fromMap(response.data) : null;

      // List<DeceasedRequestDetailsModel>?  parsedResult =   data != null ? List<DeceasedRequestDetailsModel>.from(data
      //     .map((x) => RequestItemModel.fromJson(x))): null;

      List<DeceasedIdenticalItem> parsedResult = data != null
          ? List<DeceasedIdenticalItem>.from(
              data.map((x) => DeceasedIdenticalItem.fromJson(x)))
          : [];

      final decodedResponse =
          ResponseBodyModel<List<DeceasedIdenticalItem>>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<TripDetailsModel>>> getTrips(int params) async {
    Response response;

    try {
      response = await webService.dio.put(
          "${ApiUrl.initializeTripsRquest(params)}",
          queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      List<TripDetailsModel> parsedResult = data != null
          ? List<TripDetailsModel>.from(
              data.map((x) => TripDetailsModel.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<TripDetailsModel>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> addTrip(
      int requestId, TripDetailsModel params) async {
    Response response;
    try {
      response = await webService.dio.post(ApiUrl.addNewPath(requestId),
          data: params.toJson(), queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> editTrip(
      int requestID, TripDetailsModel params) async {
    Response response;
    try {
      response = await webService.dio.post(
          ApiUrl.EditTrip(requestID, params.id!),
          data: params.toJson(),
          queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> deleteTrip(
      int tripId, int requestId) async {
    Response response;
    try {
      response = await webService.dio.delete(
          ApiUrl.deleteTrip(tripId, requestId),
          queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> deleteAttachment(
      int attachmentId, int requestId) async {
    Response response;
    try {
      response = await webService.dio.delete(
          ApiUrl.deleteAttachment(requestId, attachmentId),
          queryParameters: {"isDriver": true});

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> completeTrip(int params) async {
    Response response;
    try {
      response = await webService.dio.put(ApiUrl.completeTrip(params),
          queryParameters: {"isDriver": true});

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(response.data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<DeceasedAttachment>> uploadAttachment(
      int attachmentId, FileDataItem params) async {
    Response response;

    try {
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      String newFileName = params.fileName
          .replaceRange(0, params.fileName.indexOf("."), "$timeStamp");
      String contentTyp = lookupMimeType(params.filePath)!;
      final formData = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            params.filePath,
            filename: newFileName, //params.fileName,
            contentType: http.MediaType.parse(contentTyp),
          ),
        },
      );
      response = await webService.dio.post(
        ApiUrl.uploadAttachment(
          attachmentId,
        ),
        data: formData,
        options: Options(
          headers: {
            "fileContentType": contentTyp,
          },
        ),
      );

      var data = response.data["data"]?["result"];

      DeceasedAttachment? parsedResult =
          data != null ? DeceasedAttachment.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<DeceasedAttachment>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> upadateDriverLocation(
      UpdateDriverLocationParams params) async {
    Response response;

    try {
      response = await webService.dio.post(
        ApiUrl.updateLocation(params.requestId),
        data: params.toMap(),
      );

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> currentTrackLocation(int requestId) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.currentTrackLocation(requestId),
      );

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<TripLocationsResponseModel>> getTripsLocation(
      int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.tripLocations}/$params",
        queryParameters: {"isDriver": 0},
      );

      var data = response.data["data"];
      TripLocationsResponseModel? parsedResult =
          data != null ? TripLocationsResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<TripLocationsResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getLocations() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramLocations,
        queryParameters: {"isDriver": 0},
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getStatus() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramRequestStatus,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> editAdditionalData(
      int id, EditAdditionalRequest request) async {
    Response response;

    try {
      response = await webService.dio.post(
          ApiUrl.editAdditionalData(request.requestId!),
          data: request.toJson());

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //  CommonFunctions.sendExceptionLog(exception:  error, response: "");
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getEkramLookup(
      String params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramAnotherLookup}/$params",
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            ("errors_server_error_1").tr();
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<UserInfoResponseModel>> checkUserinfo(
      UserInfoRequestParams params) async {
    Response response;

    try {
      response = await webService.dio.post(
        ApiUrl.residentInfo,
        data: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      UserInfoResponseModel? parsedResult =
          data != null ? UserInfoResponseModel.fromJson(data) : null;

      final decodedResponse = ResponseBodyModel<UserInfoResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getActiveCities() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramActiveCities,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<ApplyDeceasedResponseModel>> bookCemetry(
      BookCemetryParamas params) async {
    Response response;

    try {
      print(params.toMap());
      response = await webService.dio.post(
        ApiUrl.bookCemetry,
        data: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      ApplyDeceasedResponseModel? parsedResult =
          data != null ? ApplyDeceasedResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<ApplyDeceasedResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<CemetryRequestDetailsModel>>
      getCemetryRequestDetails(String params) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.bookCemetryDetails.replaceAll("{}", params),
      );

      var data = response.data["data"]?["result"];
      print(data);
      CemetryRequestDetailsModel? parsedResult =
          data != null ? CemetryRequestDetailsModel.fromJson(data) : null;

      final decodedResponse =
          ResponseBodyModel<CemetryRequestDetailsModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //  CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<CemetryRequestResponseModel>> getCemetryRequests(
      GetRequestsParams params) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.bookCemetryRequests,
        queryParameters: {
          "page": params.page,
          "size": params.size,
        },
      );

      var data = response.data["data"]?["result"];

      CemetryRequestResponseModel? parsedResult =
          data != null ? CemetryRequestResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<CemetryRequestResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      String? errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getNationalityTypes() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramIdentityTypes,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getCountries() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramCountries,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getDeathCities() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.deathCities,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getBurialCities() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.burialCities,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getEkramOrgnizations(
      GetOrgnizationsParams params) async {
    Response response;

    try {
      response = await webService.dio
          .post(ApiUrl.ekramOrgnizations, data: params.toMap());

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<GraveActiveRequestDetails>>
      getActiveGraveRequestDetails(ActiveGraveRequestParams params) async {
    Response response;

    try {
      response = await webService.dio
          .get(ApiUrl.graveActiveRequestDetails(params.idNo, params.idType));

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<GraveActiveRequestDetails>.fromMap(response.data,
              parsedResult: GraveActiveRequestDetails.fromJson(data));

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<BaqieApprovalResponse> baqieApproval(
      ActiveGraveRequestParams params) async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.baquieApproval,
          queryParameters: {"id": params.idNo, "id_type": params.idType});

      var data = response.data["data"]?["result"];

      final decodedResponse = ResponseBodyModel<BaqieApprovalResponse>.fromMap(
          response.data,
          parsedResult: BaqieApprovalResponse.fromJson(data));

      return decodedResponse.data!.result!;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //   CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> verifyDeceased(VerifyDeceasedParams params) async {
    Response? response;

    try {
      response = await webService.dio.post(
        ApiUrl.verifyDeceased,
        data: params.toMap(),
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data);

      return result;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<RequestDetailsResponseModel>> requestDetails(
      int requestId) async {
    Response? response;

    try {
      response = await webService.dio.get(
        ApiUrl.deceasedRequestDetails("$requestId"),
        options: Options(
          headers: {
            /*"Authorization": token*/
          },
        ),
      );

      var data = response.data["data"]?["result"];

      RequestDetailsResponseModel? parsedResult =
          data != null ? RequestDetailsResponseModel.fromJson(data) : null;

      final decodedResponse =
          ResponseBodyModel<RequestDetailsResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> saveDeceasedInfo(
      int requestId, SaveDeceasedInfoParams params) async {
    Response? response;

    try {
      response = await webService.dio
          .post(ApiUrl.saveDeceasdInfo(requestId), data: params.toJson());
      // final data = response.data;
      //
      // final result = ResponseBodyModel.fromMap(data).data?.result;
      //
      // return result;

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel> saveDeathBurialInfo(
      int requestId, SaveDeathBurialInfoParams params) async {
    Response? response;

    try {
      response = await webService.dio.post(
        ApiUrl.saveDeathBurialInfo(requestId),
        data: params.toJson(),
      );
      final data = response.data;

      return ResponseBodyModel.fromMap(data);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>>
      getSpecialTransportReasonsLookUp() async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.specialTransportReasons);

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            ("errors_server_error_1").tr();
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getCemeteryTypesLookUp() async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.graveTypes);

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            ("errors_server_error_1").tr();
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getCemetriesLookUp(
      int requestId, CemetriesParams params) async {
    Response response;

    try {
      response = await webService.dio
          .post(ApiUrl.cemetries(requestId), data: params.toJson());

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            ("errors_server_error_1").tr();
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getTransportationCompaniesLookUp(
      int requestId, TransportationCompaniesParams params) async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.transportCompanies(requestId),
          queryParameters: params.toJson());

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            ("errors_server_error_1").tr();
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getLaundriesLookUp(
      int transportId,
      List<int?> cityIds,
      MosqueGhuslPlacesParams params) async {
    Response response;

    try {
      response = await webService.dio.post(ApiUrl.ekramLaundries(transportId),
          data: jsonEncode(cityIds), queryParameters: params.toJson());

      var data = response.data["data"]?["result"];

      List<LookUpItemLocationModel> parsedResult = data != null
          ? List<LookUpItemLocationModel>.from(
              data.map((x) => LookUpItemLocationModel.fromJson(x)))
          : [];

      final decodedResponse =
          ResponseBodyModel<List<LookUpItemLocationModel>>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //  //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getMosquesLookUp(
      int transportId,
      List<int?> cityIds,
      MosqueGhuslPlacesParams params) async {
    Response response;

    try {
      response = await webService.dio.post(ApiUrl.ekramMosques(transportId),
          data: jsonEncode(cityIds), queryParameters: params.toJson());

      var data = response.data["data"]?["result"];

      List<LookUpItemLocationModel> parsedResult = data != null
          ? List<LookUpItemLocationModel>.from(
              data.map((x) => LookUpItemLocationModel.fromJson(x)))
          : [];

      final decodedResponse =
          ResponseBodyModel<List<LookUpItemLocationModel>>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<MadinahEmirateApprovalStatusResponseModel>>
      madinahEmirateApprovalStatus(int cemetryId, int id, int idType) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.madinahEmirateApprovalStatus(cemetryId, id, idType),
      );

      var data = response.data["data"]?["result"];

      MadinahEmirateApprovalStatusResponseModel? parsedResult = data != null
          ? MadinahEmirateApprovalStatusResponseModel.fromJson(data)
          : null;

      final decodedResponse =
          ResponseBodyModel<MadinahEmirateApprovalStatusResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getPrayers() async {
    Response response;

    try {
      response = await webService.dio.get(ApiUrl.prayers);

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);
      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            ("errors_server_error_1").tr();
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }
      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          // CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> ekramTransportValidateSubmit(
      int requestId, EkramTransportValidateSubmitParams params) async {
    Response? response;

    try {
      response = await webService.dio.post(
          ApiUrl.ekramTransportValidateSubmit(requestId),
          data: params.toJson());
      final data = response.data;

      return ResponseBodyModel.fromMap(data);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
