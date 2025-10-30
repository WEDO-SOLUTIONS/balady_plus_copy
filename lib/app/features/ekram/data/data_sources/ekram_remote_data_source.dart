import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/ekram/data/model/add_trip_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/baqie_approval_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/deceased_request_details_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_attachment_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/look_up_item_location_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/trip_details_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/trip_location_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/upload_letter_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/user_info_response_model/user_info_response_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/update_driver_location.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
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

abstract class EkramRemoteDataSource {
  Future<ResponseBodyModel<List<LookUpItem>>> getCities();

  Future<ResponseBodyModel<List<LookUpItem>>> getDeathCities();

  Future<ResponseBodyModel<List<LookUpItem>>> getHospitals(int params);
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getMosques(
      int params);
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getLaundries(
      int params);

  Future<ResponseBodyModel<List<LookUpItem>>> getNationalities();

  Future<ResponseBodyModel<List<LookUpItem>>> getLookup(int params);

  Future<ResponseBodyModel<ApplyDeceasedResponseModel>> applyDeceasedTransport(
      ApplyDeceasedParams params);
  Future<ResponseBodyModel<TransportRequestResponseModel>>
      getDeceasedTransportRequests(GetRequestsParams params);

  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getTransportRequestDetails(int params);
  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getDriverRequestDetails(int params);

  Future<ResponseBodyModel<List<TripDetailsModel>>> getTrips(int params);

  Future<ResponseBodyModel> addTrip(AddTripParams params);
  Future<ResponseBodyModel<dynamic>> completeTrip(int params);
  Future<ResponseBodyModel<dynamic>> deleteTrip(int params);

  Future<ResponseBodyModel<dynamic>> uploadLetter(UploadLetterParamas params);

  Future<ResponseBodyModel<dynamic>> upadateDriverLocation(
      UpdateDriverLocationParams params);

  Future<ResponseBodyModel<TripLocationsResponseModel>> getTripsLocation(
      int params);

  Future<ResponseBodyModel<List<LookUpItem>>> getStatus();
  Future<ResponseBodyModel<List<LookUpItem>>> getLocations();

  Future<EkramAttachmentResponse> downLoadAttachment(int id);

  Future<ResponseBodyModel<List<LookUpItem>>> getEkramLookup(String params);

  Future<ResponseBodyModel<UserInfoResponseModel>> checkUserinfo(
      UserInfoRequestParams params);

  Future<ResponseBodyModel<List<LookUpItem>>> getActiveCities();

  Future<ResponseBodyModel<List<LookUpItem>>> getCemetries(
      GetCemetriesParams params);

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

  Future<ResponseBodyModel<GraveActiveRequestDetails>>
      getActiveGraveRequestDetails(ActiveGraveRequestParams params);

  Future<BaqieApprovalResponse> baqieApproval(ActiveGraveRequestParams params);
}

class EkramRemoteDataSourceImpl extends EkramRemoteDataSource {
  final WebService webService;

  EkramRemoteDataSourceImpl({required this.webService});

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getNationalities() async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramNationalities,
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel<List<LookUpItem>>> getHospitals(int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramHospitals}/$params",
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
      response = await webService.dio.get(
        ApiUrl.deceasedTransportRequests,
        queryParameters: {
          "isDriver": params.isDriver ? 1 : 0,
          "page": params.page,
          "size": params.size,
          if (int.tryParse(params.text ?? "") != null) "requestId": params.text,
          if ((params.text?.isNotEmpty ?? false) &&
              int.tryParse(params.text ?? "") == null)
            "deceasedName": params.text,
          if ((params.deceasedTransportRequestStatusId != null))
            "requestStatusList": params.deceasedTransportRequestStatusId,
          if ((params.transportLocationStatusId != null))
            "transportLocationStatusId": params.transportLocationStatusId,
          if ((params.isMultiCity != null)) "isMultiCity": params.isMultiCity,
        },
      );

      var data = response.data["data"]?["result"];
      Map<String, dynamic> x = {};
      x["items"] = data;
      TransportRequestResponseModel? parsedResult =
          data != null ? TransportRequestResponseModel.fromMap(x) : null;

      final decodedResponse =
          ResponseBodyModel<TransportRequestResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getDriverRequestDetails(int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.deceasedTransportRequestDetails}/$params",
        queryParameters: {"isDriver": 1},
      );

      var data = response.data["data"]?["result"];

      DeceasedRequestDetailsModel? parsedResult =
          data != null ? DeceasedRequestDetailsModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<DeceasedRequestDetailsModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
      response = await webService.dio.get(
        "${ApiUrl.ekramGetTrips}/$params",
        queryParameters: {"isDriver": 1},
      );

      var data = response.data["data"]?["result"];

      List<TripDetailsModel> parsedResult = data != null
          ? List<TripDetailsModel>.from(
              data.map((x) => TripDetailsModel.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<TripDetailsModel>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel> addTrip(AddTripParams params) async {
    Response response;
    try {
      print(params.toMap());
      response = await webService.dio.post(
        ApiUrl.applyTrip,
        data: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      ApplyDeceasedResponseModel? parsedResult =
          data != null ? ApplyDeceasedResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<ApplyDeceasedResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getLaundries(
      int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramLaundries.replaceAll("{}", params.toString()),
      );

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
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getMosques(
      int params) async {
    Response response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramMosques.replaceAll("{}", params.toString()),
      );

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
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel<dynamic>> deleteTrip(int params) async {
    Response response;
    try {
      response = await webService.dio.post(
        "${ApiUrl.deleteTrip}/$params",
      );

      var data = response.data["data"]?["result"];

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(response.data);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
      response = await webService.dio.post(
        "${ApiUrl.completeTrip}/$params",
      );

      var data = response.data["data"]?["result"];

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(response.data);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
  Future<ResponseBodyModel> uploadLetter(UploadLetterParamas params) async {
    Response response;
    try {
      response = await webService.dio.post(
        ApiUrl.uploadLetter,
        data: params.toMap(),
      );

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
        response.data,
      );

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
        ApiUrl.updateLocation,
        data: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
  Future<EkramAttachmentResponse> downLoadAttachment(int id) async {
    Response response;

    try {
      response = await webService.dio.get("${ApiUrl.ekramAttachments}/$id",
          options: Options(responseType: ResponseType.bytes));

      var data = response.data;
      return EkramAttachmentResponse(
          data: data, type: response.headers["Content-Type"]?.first ?? "");
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
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
}
