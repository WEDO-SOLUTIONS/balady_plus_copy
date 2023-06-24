import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundException, ServerException;
import '../../../../core/services/services_exports.dart' show WebService;
import '../../../../core/utils/utils_exports.dart' show ApiUrl, Log, WithDelay;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../../objections/data/models/objection_details_model.dart';
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

  Future<CreateObjectionResponseModel> createObjection(
      {required CreateObjectionParams params});

  Future<ObjectionDetailsModel> getObjectionDetails(String id);
  Future<TransactionDetailsModel> getTransactionDetails(
      TransactionDetailsParams params);
}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;

  RequestsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<ObjectableTransactionsModel>> getObjectionRequests(
    TransactionsParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
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
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<RequestStatusModel>> getRequestStatuses() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.objectionsRequestStatus,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<RequestStatusModel>(
              (e) => RequestStatusModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<RequestTypeModel>> getRequestTypes() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.applicationsLookUp,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<RequestTypeModel>(
              (e) => RequestTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<RequestSubTypeModel>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.servicesByApplicationId(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<RequestSubTypeModel>(
              (e) => RequestSubTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<CreateObjectionResponseModel> createObjection(
      {required CreateObjectionParams params}) async {
    try {
      final response =
          await webService.dio.post(ApiUrl.postObjection, data: params.toMap());
      var data = response.data["data"]?["result"];

      data.toString().successLog();

      final result = ResponseBodyModel<CreateObjectionResponseModel>.fromMap(
          response.data,
          parsedResult: CreateObjectionResponseModel.fromJson(data));

      return result.data!.result!;
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<UploadFileResponse> uploadFile(
      {required UploadFileParams params}) async {
    var response;
    print(params.toMap());
    try {
      response = await webService.dio.post(ApiUrl.uploadFile,
          data: params.toMap(), options: Options(headers: {"X-Service-Id": 2}));
      print(response.data);

      var data = response.data["data"]["result"]["Documents"][0]["Document"][0];
      print("hhh");
      print(data);
      var parsedResult =
          data != null ? UploadFileResponse.fromJson(data) : null;
      print("hhh");
      parsedResult?.index = params.index;

      return parsedResult!.toFuture();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<ObjectionDetailsModel> getObjectionDetails(String id) async {
    try {
      final response = await webService.dio
          .post(ApiUrl.objectionRequestDetails, queryParameters: {
        "ObjectionRequestID": id,
      });

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ObjectionDetailsModel.fromJson(result);
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<TransactionDetailsModel> getTransactionDetails(
      TransactionDetailsParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.transactionsRequestDetails(params.applicationId),
        queryParameters: {"transactionNumber": params.id},
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return TransactionDetailsModel.fromJson(result);
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }
}
