import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show APIException, NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../invoices_exports.dart'
    show
        InvoiceDetailsModel,
        InvoiceDetailsParamsModel,
        InvoiceStatusModel,
        InvoiceSubTypeModel,
        InvoiceSubTypeParamsModel,
        InvoiceTypeModel,
        InvoicesModel,
        InvoicesParamsModel;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class InvoicesRemoteDataSource {
  Future<List<InvoicesModel>> getInvoices(
    InvoicesParamsModel params,
  );

  Future<List<InvoiceStatusModel>> getInvoiceStatuses();

  Future<List<InvoiceTypeModel>> getInvoiceTypes();

  Future<List<InvoiceSubTypeModel>> getInvoiceSubTypes(
    InvoiceSubTypeParamsModel params,
  );

  Future<InvoiceDetailsModel> getInvoiceDetails(
    InvoiceDetailsParamsModel params,
  );
}

class InvoicesRemoteDataSourceImplementation
    implements InvoicesRemoteDataSource {
  final WebService webService;

  InvoicesRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<InvoicesModel>> getInvoices(
    InvoicesParamsModel params,
  ) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.invoices,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<InvoicesModel>(
              (e) => InvoicesModel.fromMap(e as Map<String, dynamic>))
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
  Future<List<InvoiceStatusModel>> getInvoiceStatuses() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.invoiceStatuses,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<InvoiceStatusModel>(
              (e) => InvoiceStatusModel.fromMap(e as Map<String, dynamic>))
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
  Future<List<InvoiceTypeModel>> getInvoiceTypes() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.invoiceTypes,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<InvoiceTypeModel>(
              (e) => InvoiceTypeModel.fromMap(e as Map<String, dynamic>))
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
  Future<List<InvoiceSubTypeModel>> getInvoiceSubTypes(
    InvoiceSubTypeParamsModel params,
  ) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.invoiceSubTypes(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<InvoiceSubTypeModel>(
              (e) => InvoiceSubTypeModel.fromMap(e as Map<String, dynamic>))
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
  Future<InvoiceDetailsModel> getInvoiceDetails(
    InvoiceDetailsParamsModel params,
  ) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.invoiceDetails,
        data: params.toMap(),
        options: params.xSourceApp != null
            ? Options(
                headers: {
                  "x-source-app": params.xSourceApp,
                },
              )
            : null,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return InvoiceDetailsModel.fromJson(result);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
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
