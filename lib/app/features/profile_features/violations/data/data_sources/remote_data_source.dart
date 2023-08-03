import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart'
    show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;

import '../../violations_exports.dart'
    show InvoiceStatusesModel, ViolationDetailsModel, ViolationsModel, ViolationsParamsModel, ViolationsStatusModel;

abstract class ViolationsRemoteDataSource {
  Future<List<ViolationsModel>> getViolations(
      ViolationsParamsModel params,
      );
  Future<List<ViolationsStatusModel>> getViolationsStatuses();
  Future<List<InvoiceStatusesModel>> getInvoiceStatuses();

  Future<ViolationDetailsModel> getViolationDetails(String id);

}

class ViolationsRemoteDataSourceImplementation
    implements ViolationsRemoteDataSource {
  final WebService webService;

  ViolationsRemoteDataSourceImplementation({required this.webService});



  @override
  Future<ViolationDetailsModel> getViolationDetails(String id) async {
    try {
      final response = await webService.dio
          .get(ApiUrl.violationDetails, queryParameters: {
        "violationNumber": id,
      });

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ViolationDetailsModel.fromJson(result);
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
        print(ex.toString());
        rethrow;
      } else {
        print(ex.toString());
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<ViolationsModel>> getViolations(
      ViolationsParamsModel params,
      ) async {
    try {
      final response = await webService.dio.post(
        ApiUrl.violations,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<ViolationsModel>((e) =>
          ViolationsModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<ViolationsStatusModel>> getViolationsStatuses() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.violationsStatus,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<ViolationsStatusModel>(
              (e) => ViolationsStatusModel.fromMap(e as Map<String, dynamic>))
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
  Future<List<InvoiceStatusesModel>> getInvoiceStatuses() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.invoiceStatus,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<InvoiceStatusesModel>(
              (e) => InvoiceStatusesModel.fromMap(e as Map<String, dynamic>))
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
}
