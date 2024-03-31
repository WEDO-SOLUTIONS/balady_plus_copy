import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../model/construction_license_inquery_data_model.dart';

abstract class ConstructionLicenseInqueryRemoteDataSource {
  Future<ResponseBodyModel<ConstructionLicenseDataModel>> getLicenseData(
      int licenseNumber, String date);
}

class ConstructionLicenseInqueryRemoteDataSourceImplementation
    implements ConstructionLicenseInqueryRemoteDataSource {
  final WebService webService;

  ConstructionLicenseInqueryRemoteDataSourceImplementation(
      {required this.webService});

  @override
  Future<ResponseBodyModel<ConstructionLicenseDataModel>> getLicenseData(
      int licenseNumber, String date) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getConstructionLicenseData(licenseNumber, date),
      );
      final data = response.data;

      var parsedResult = data != null
          ? ConstructionLicenseDataModel.fromJson(data["data"]["result"])
          : null;
      final decodedResponse =
          ResponseBodyModel<ConstructionLicenseDataModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();

      // final result = ResponseBodyModel.fromMap(data).data?.result;
      // CommercialLicenseDataModel commercialLicencedata = CommercialLicenseDataModel.fromJson(result!);
      // return  commercialLicencedata;
    } on DioError catch (error) {
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      // "Catched $ex".errorLog();

      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
