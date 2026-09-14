import 'dart:core';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/services_exports.dart' show WebService;
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/location/data/model/gis_response_model.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
      response = await webService.dio.get(ApiUrl.gis, queryParameters: params.toMap());

      var data = response.data["data"]["result"];

      final decodedResponse = GISResponseModel.fromMap(data);

      return decodedResponse.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }
}
