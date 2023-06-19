import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../invoices_exports.dart'
    show
        InvoicesModel,
        InvoiceStatusModel,
        InvoiceSubTypeModel,
        InvoiceSubTypeParamsModel,
        InvoiceTypeModel,
        InvoicesParamsModel;

abstract class InvoicesRemoteDataSource {
  Future<List<InvoicesModel>> getInvoices(
    InvoicesParamsModel params,
  );
  Future<List<InvoiceStatusModel>> getInvoiceStatuses();
  Future<List<InvoiceTypeModel>> getInvoiceTypes();
  Future<List<InvoiceSubTypeModel>> getInvoiceSubTypes(
    InvoiceSubTypeParamsModel params,
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
    try {
      final response = await webService.dio.post(
        ApiUrl.invoices,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<InvoicesModel>(
              (e) => InvoicesModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<InvoiceStatusModel>> getInvoiceStatuses() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.invoiceStatuses,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<InvoiceStatusModel>(
              (e) => InvoiceStatusModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<InvoiceTypeModel>> getInvoiceTypes() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.invoiceTypes,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<InvoiceTypeModel>(
              (e) => InvoiceTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<InvoiceSubTypeModel>> getInvoiceSubTypes(
    InvoiceSubTypeParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.invoiceSubTypes(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<InvoiceSubTypeModel>(
              (e) => InvoiceSubTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
