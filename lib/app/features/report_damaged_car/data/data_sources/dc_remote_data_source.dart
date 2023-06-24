import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/services_exports.dart' show WebService;
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../vd/vd_exports.dart'
    show CreateIncidentResponseModel, CreateIncidentParams;
import '../../damaged_cars_exports.dart'
    show
        ActiveLocationParams,
        CarModelModel,
        CarTypeModel,
        VehicleResponseModel;

abstract class DCRemoteDataSource {
  Future<ResponseBodyModel<CreateIncidentResponseModel>>
      createIncidentRegistered({required CreateIncidentParams params});
  Future<List<CarModelModel>> getCarModels({required String params});
  Future<List<CarTypeModel>> getCarTypes();
  Future<bool> checkActiveLocation({required ActiveLocationParams params});
}

class DCRemoteDataSourceImpl extends DCRemoteDataSource {
  final WebService webService;

  DCRemoteDataSourceImpl({required this.webService});

  @override
  Future<ResponseBodyModel<CreateIncidentResponseModel>>
      createIncidentRegistered({required CreateIncidentParams params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.createIncidentRegistered,
        data: params.toMap(),
      );

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? CreateIncidentResponseModel.fromMap(data) : null;
      final decodedResponse =
          ResponseBodyModel<CreateIncidentResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CreateIncidentResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, errorCode: errorCode);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_1").tr());
      }
    }
  }

  @override
  Future<List<CarModelModel>> getCarModels({required String params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.dcCarModel,
        queryParameters: {
          "CompanyID": params,
        },
      );

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<CarModelModel>(
              (e) => CarModelModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<CarTypeModel>> getCarTypes() async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.dcCarTypes,
      );

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<CarTypeModel>(
              (e) => CarTypeModel.fromJson(e as Map<String, dynamic>))
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
  Future<bool> checkActiveLocation(
      {required ActiveLocationParams params}) async {
    var response;

    try {
      response = await webService.dio
          .post(ApiUrl.veichleRecoveryNotes, data: params.toMap());

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: true);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode);
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM   CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}
