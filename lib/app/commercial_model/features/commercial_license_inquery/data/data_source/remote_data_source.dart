import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../domain/entity/commercial_license_data_entity.dart';
import '../model/commercial_license_data_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';
abstract class CommercialLicenseQueryRemoteDataSource {
  Future<ResponseBodyModel<CommercialLicenseDataModel>>
      getCommercialLicenseData(int licenseNumber, int unifiedFacilityNumber);
}

class CommercialLicenseQueryRemoteDataSourceImplementation
    implements CommercialLicenseQueryRemoteDataSource {
  final WebService webService;

  CommercialLicenseQueryRemoteDataSourceImplementation(
      {required this.webService});

  @override
  Future<ResponseBodyModel<CommercialLicenseDataModel>>
      getCommercialLicenseData(
          int licenseNumber, int unifiedFacilityNumber) async {
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.getCommercialLicenseData(licenseNumber, unifiedFacilityNumber),
      );
      final data = response.data;

      var parsedResult = data != null
          ? CommercialLicenseDataModel.fromJson(data["data"]["result"])
          : null;
      final decodedResponse =
          ResponseBodyModel<CommercialLicenseDataModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();

      // final result = ResponseBodyModel.fromMap(data).data?.result;
      // CommercialLicenseDataModel commercialLicencedata = CommercialLicenseDataModel.fromJson(result!);
      // return  commercialLicencedata;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "DioError $error".errorLog();
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
      // "Catched $error".errorLog();

      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
