import 'package:balady_plus/app/features/objectable_transactions/domain/entities/enquiry_objection_reply_params.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/validate_objection_params.dart';
import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/errors/errors_exports.dart'
    show APIException, NoDataFoundException, ServerException;
import '../../../../core/services/services_exports.dart' show WebService;
import '../../../../core/utils/utils_exports.dart' show ApiUrl, Log, WithDelay;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../../objections/data/models/objection_details_model.dart';
import '../../domain/entities/objection_enquiry_details.dart';
import '../../domain/entities/transaction_details_params.dart';
import '../../objections_exports.dart'
    show
        ObjectableTransactionsModel,
        RequestStatusModel,
        RequestSubTypeModel,
        RequestSubTypeParamsModel,
        RequestTypeModel,
        TransactionsParamsModel,
        CreateObjectionParams,
        CreateObjectionResponseModel,
        UploadFileResponse,
        UploadFileParams;
import '../models/transaction_details_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class RequestsRemoteDataSource {
  Future<List<ObjectableTransactionsModel>> getObjectionRequests(
    TransactionsParamsModel params,
  );
  Future<List<RequestStatusModel>> getRequestStatuses();
  Future<List<RequestTypeModel>> getRequestTypes();
  Future<List<RequestSubTypeModel>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  );

  Future<UploadFileResponse> uploadFile({required UploadFileParams params});
  Future<UploadFileResponse> uploadFileV2({required UploadFileParams params});

  Future<CreateObjectionResponseModel> createObjection(
      {required CreateObjectionParams params});

  Future<ObjectionDetailsModel> getObjectionDetails(String id);
  Future<TransactionDetailsModel> getTransactionDetails(
      TransactionDetailsParams params);

  Future<bool> validateObjectableTransaction(ValidateObjectionParams params);

  Future<ObjectionEnquiryDetails> getEnquiryObjectionDetails(String id);

  Future<dynamic> replyEnquiryObjectionDetails(
      EnquiryObjectionReplyDetails request);
}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;

  RequestsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<ObjectableTransactionsModel>> getObjectionRequests(
    TransactionsParamsModel params,
  ) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.transactionsRequests,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<ObjectableTransactionsModel>((e) =>
              ObjectableTransactionsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<List<RequestStatusModel>> getRequestStatuses() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.objectionsRequestStatus,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<RequestStatusModel>(
              (e) => RequestStatusModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<List<RequestTypeModel>> getRequestTypes() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.applicationsLookUp,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<RequestTypeModel>(
              (e) => RequestTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<List<RequestSubTypeModel>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  ) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.servicesByApplicationId(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<RequestSubTypeModel>(
              (e) => RequestSubTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<CreateObjectionResponseModel> createObjection(
      {required CreateObjectionParams params}) async {
    var response;
    try {
      response =
          await webService.dio.post(ApiUrl.postObjection, data: params.toMap());
      var data = response.data["data"]?["result"];

      data.toString().successLog();

      final result = ResponseBodyModel<CreateObjectionResponseModel>.fromMap(
          response.data,
          parsedResult: CreateObjectionResponseModel.fromJson(data));

      return result.data!.result!;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<UploadFileResponse> uploadFile(
      {required UploadFileParams params}) async {
    var response;
    try {
      response = await webService.dio.post(ApiUrl.uploadFile,
          data: params.toMap(), options: Options(headers: {"X-Service-Id": 2}));

      var data = response.data["data"]["result"]["Documents"][0]["Document"][0];

      var parsedResult =
          data != null ? UploadFileResponse.fromJson(data) : null;
      parsedResult?.index = params.index;

      return parsedResult!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<UploadFileResponse> uploadFileV2(
      {required UploadFileParams params}) async {
    var response;
    try {
      response = await webService.dio.post(ApiUrl.uploadFileV2,
          data: params.toMap(), options: Options(headers: {"X-Service-Id": 2}));

      var data = response.data["data"]["result"]["Documents"][0]["Document"][0];

      var parsedResult =
          data != null ? UploadFileResponse.fromJson(data) : null;
      parsedResult?.index = params.index;

      return parsedResult!.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<ObjectionDetailsModel> getObjectionDetails(String id) async {
    var response;
    try {
      response = await webService.dio
          .get(ApiUrl.objectionRequestDetails, queryParameters: {
        "ObjectionRequestID": id,
      });

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ObjectionDetailsModel.fromJson(result);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<TransactionDetailsModel> getTransactionDetails(
      TransactionDetailsParams params) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.transactionsRequestDetails(params.applicationId),
        queryParameters: {"transactionNumber": params.id},
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return TransactionDetailsModel.fromJson(result);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<bool> validateObjectableTransaction(
      ValidateObjectionParams params) async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.validateObjectionSubmit(
          params.applicationId!, params.transactionId!));

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      "Catched $error".errorLog();
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
  Future<ObjectionEnquiryDetails> getEnquiryObjectionDetails(String id) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.objectionEnquiryDetails(id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ObjectionEnquiryDetails.fromJson(result);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      print(error);
      "Catched $error".errorLog();
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
  Future<dynamic> replyEnquiryObjectionDetails(
      EnquiryObjectionReplyDetails request) async {
    var response;
    try {
      response = await webService.dio
          .post(ApiUrl.createEnquiryDetails, data: request.toJson());

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
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
      print(error);
      "Catched $error".errorLog();
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
