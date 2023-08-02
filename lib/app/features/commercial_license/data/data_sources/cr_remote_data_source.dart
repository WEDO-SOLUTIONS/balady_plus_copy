import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/errors_exports.dart';
import '../../../../core/services/services_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';

abstract class CrRemoteDataSource {
  Future<ResponseBodyModel<RecordInfoModel>> getRecordInfo(
      {required String crNumber});
  Future<List<SubActivityModel>> getSubActivities({required String isicCode});
  // Future<ResponseBodyModel<SubActivityModelDetailsModel>> getSubActivityDetails(
  //     {required String subActivityId});


}

class CrRemoteDataSourceImpl extends CrRemoteDataSource {
  final WebService webService;

  CrRemoteDataSourceImpl({required this.webService});

  @override
  Future<ResponseBodyModel<RecordInfoModel>> getRecordInfo(
      {required String crNumber}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.recordInfo.replaceAll("crNumber", crNumber),
      );

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? RecordInfoModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
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
  Future<List<SubActivityModel>> getSubActivities(
      {required String isicCode}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.subActivities.replaceAll("isicCode", isicCode),
      );

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<SubActivityModel>(
              (e) => SubActivityModel.fromJson(e as Map<String, dynamic>))
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
  //
  // @override
  // Future<ResponseBodyModel<SubActivityModelDetailsModel>> getSubActivityDetails(
  //     {required String subActivityId}) async {
  //   var response;
  //
  //   try {
  //     response = await webService.dio.get(
  //       ApiUrl.recordInfo.replaceAll("crNumber", crNumber),
  //     );
  //
  //     var data = response.data["data"]["result"];
  //
  //     var parsedResult = data != null ? RecordInfoModel.fromJson(data) : null;
  //     final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
  //         response.data,
  //         parsedResult: parsedResult);
  //
  //     return decodedResponse.toFuture();
  //   } on DioError catch (error) {
  //     var errorCode;
  //     try {
  //       final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
  //         error.response?.data,
  //       );
  //       errorCode = decodedResponse.data?.responseCode;
  //     } catch (ex) {}
  //
  //     throw ServerException(error.toString(),
  //         statusCode: error.response?.statusCode, errorCode: errorCode);
  //   } catch (ex) {
  //     if (ex is ServerException)
  //       throw ex;
  //     else {
  //       try {
  //         //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
  //       } catch (ex) {}
  //       throw ServerException(("errors_server_error_1").tr());
  //     }
  //   }
  // }


}
