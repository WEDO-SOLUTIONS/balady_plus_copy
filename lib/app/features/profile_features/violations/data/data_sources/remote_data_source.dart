import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart'
    show ApiUrl, Log, WithDelay;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;

import '../../../../objections/data/models/objection_details_model.dart';
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
  Future<List<RequestStatusModel>> getRequestStatuses();
  Future<List<RequestTypeModel>> getRequestTypes();
  Future<List<RequestSubTypeModel>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  );

  Future<TransactionDetailsModel> getTransactionDetails(
      TransactionDetailsParams params);
}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;

  RequestsRemoteDataSourceImplementation({required this.webService});

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
