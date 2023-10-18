import 'dart:async';
import 'dart:core';

import 'package:balady_plus/app/core/utils/utils_exports.dart' show WithDelay;
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        CategoryResponseModel,
        CategoryParams,
        SplResponseModel,
        SplParams,
        SPLDetailsParams,
        GISParams,
        GISResponseModel,
        SPLDetailsResponseModel,
        UploadFileResponseModel,
        UploadFileParams,
        OTPResponseModel,
        OTPParams,
        CreateIncidentParams,
        CreateIncidentResponseModel;
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/services_exports.dart'
    show WebService;
import 'package:balady_plus/app/core/utils/common_functions.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';

abstract class VDRemoteDataSource {
  Future<GISResponseModel> getGISData({required GISParams params});
}

class VDRemoteDataSourceImpl extends VDRemoteDataSource {
  final WebService webService;

  VDRemoteDataSourceImpl({required this.webService});

  @override
  Future<GISResponseModel> getGISData({required GISParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.gis,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"]["result"];

      final decodedResponse = GISResponseModel.fromMap(data);

      return decodedResponse.toFuture();
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
        throw ServerException(("errors_server_error_1").tr());
      }
    }
  }
}
