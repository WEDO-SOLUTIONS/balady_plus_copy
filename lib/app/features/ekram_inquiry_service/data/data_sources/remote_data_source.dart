import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entities/find_cemetry_request.dart';
import '../../domain/entities/find_grave_request.dart';
import '../../domain/entities/send_otp_params.dart';
import '../../domain/entities/verify_otp_params.dart';
import '../models/find_cemetry_response_model.dart';
import '../models/find_grave_response_model.dart';
import '../models/orgnization_charity_list.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class EkramServicesRemoteDataSource {
  Future<FindCemetryResponse> findCemetries(
      {required FindCemetryRequest params});

  Future<FindGraveResponse> findGraveLocations(
      {required FindGraveRequest params});

  Future<List<LookUpItem>> getCities();

  Future<List<LookUpItem>> getDistrcits({required int params});

  Future<EkramCharityOrgnizationResponse> getCharityOrgnizations(
      {required int params});

  Future<List<LookUpItem>> getEkramIdentityTypes();

  Future<SendOTPResponseModel> sendOTPForPrint({required SendOTPParams params});
  Future<VerifyOTPResponseModel> verifyOTPForPrint(
      {required VerifyOTPParams params});
}

class EkramServicesRemoteDataSourceImpl extends EkramServicesRemoteDataSource {
  final WebService webService;
  EkramServicesRemoteDataSourceImpl({required this.webService});

  @override
  Future<FindCemetryResponse> findCemetries(
      {required FindCemetryRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.ekramFindCemetries,
        data: params.toMap(),
      );
      final data = response.data;

      return FindCemetryResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<FindGraveResponse> findGraveLocations(
      {required FindGraveRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.ekramFindGraves,
        data: params.toJson(),
      );
      final data = response.data;

      return FindGraveResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<LookUpItem>> getCities() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramNewCities,
      );
      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<LookUpItem>> getDistrcits({required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramDistricts(params),
      );
      var data = response.data["data"]?["result"];

      List<LookUpItem> parsedResult = data != null
          ? List<LookUpItem>.from(data.map((x) => LookUpItem.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<LookUpItem>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<EkramCharityOrgnizationResponse> getCharityOrgnizations(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.ekramCharity(params),
      );
      var data = response.data["data"];

      return EkramCharityOrgnizationResponse.fromJson(data);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<LookUpItem>> getEkramIdentityTypes() async {
    var response;

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

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error, stackTrace) {
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<SendOTPResponseModel> sendOTPForPrint(
      {required SendOTPParams params}) async {
    var response;

    try {
      response = await webService.dio
          .post(ApiUrl.ekramPrintCertificate, data: params.toMap());
      var data = response.data["data"]?["result"];

      return SendOTPResponseModel.fromJson(data);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<VerifyOTPResponseModel> verifyOTPForPrint(
      {required VerifyOTPParams params}) async {
    var response;

    try {
      response = await webService.dio
          .get(ApiUrl.validatePrintCertificate(params.guid, params.otp));
      var data = response.data["data"]?["result"];

      return VerifyOTPResponseModel.fromJson(data);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
