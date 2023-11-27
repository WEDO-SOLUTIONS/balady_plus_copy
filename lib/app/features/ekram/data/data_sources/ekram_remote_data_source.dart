import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/ekram/data/model/add_trip_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/deceased_request_details_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_attachment_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/look_up_item_location_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/trip_details_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/trip_location_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/upload_letter_params.dart';
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

abstract class EkramRemoteDataSource {
  Future<ResponseBodyModel<List<LookUpItem>>> getCities();

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
}

class EkramRemoteDataSourceImpl extends EkramRemoteDataSource {
  final WebService webService;

  EkramRemoteDataSourceImpl({required this.webService});

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getNationalities() async {
    var response;

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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getCities() async {
    var response;

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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getHospitals(int params) async {
    var response;

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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<ApplyDeceasedResponseModel>> applyDeceasedTransport(
      ApplyDeceasedParams params) async {
    var response;

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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getLookup(int params) async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramLookup}/$params",
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<TransportRequestResponseModel>>
      getDeceasedTransportRequests(GetRequestsParams params) async {
    var response;

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

      TransportRequestResponseModel? parsedResult =
          data != null ? TransportRequestResponseModel.fromMap(data) : null;

      final decodedResponse =
          ResponseBodyModel<TransportRequestResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //   //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getTransportRequestDetails(int params) async {
    var response;

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
    } on DioError catch (error) {
      print(error);
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          // //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<DeceasedRequestDetailsModel>>
      getDriverRequestDetails(int params) async {
    var response;

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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //   //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<TripDetailsModel>>> getTrips(int params) async {
    var response;

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
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> addTrip(AddTripParams params) async {
    var response;
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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getLaundries(
      int params) async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramLaundries}/$params",
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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //  //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItemLocationModel>>> getMosques(
      int params) async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramMosques}/$params",
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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> deleteTrip(int params) async {
    var response;
    try {
      response = await webService.dio.post(
        "${ApiUrl.deleteTrip}/$params",
      );

      var data = response.data["data"]?["result"];

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(response.data);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<dynamic>> completeTrip(int params) async {
    var response;
    try {
      response = await webService.dio.post(
        "${ApiUrl.completeTrip}/$params",
      );

      var data = response.data["data"]?["result"];

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(response.data);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> uploadLetter(UploadLetterParamas params) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.uploadLetter,
        data: params.toMap(),
      );

      final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
        response.data,
      );

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      print(error);
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel> upadateDriverLocation(
      UpdateDriverLocationParams params) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.updateLocation,
        data: params.toMap(),
      );

      var data = response.data["data"]?["result"];

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<TripLocationsResponseModel>> getTripsLocation(
      int params) async {
    var response;

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
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode,
          errorCode: errorCode,
          dioError: error);
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getLocations() async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramLocations}",
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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<LookUpItem>>> getStatus() async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.ekramRequestStatus}",
      );

      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
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
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //  CommonFunctions.sendExceptionLog(exception: ex, response: "");
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}
