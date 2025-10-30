import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/violation_guide/domain/entites/regulation_clauses_details_params.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../models/weather_alerts_request_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class WeatherAlertsRemoteDataSource {
  Future<bool> sendLocationToGetWeatherAlerts(
    WeatherAlertRequestModel params,
  );
}

class WeatherAlertsRemoteDataSourceImpl extends WeatherAlertsRemoteDataSource {
  final WebService webService;

  WeatherAlertsRemoteDataSourceImpl({required this.webService});

  @override
  Future<bool> sendLocationToGetWeatherAlerts(
      WeatherAlertRequestModel params) async {
    var response;

    SentryEvent event3 = SentryEvent(
        user: SentryUser(id: "123123"),
        transaction: "tracking",
        message: SentryMessage(params.toMap().toString()),
        exceptions: [
          SentryException(
              type: "Location_Updates_Tracking",
              value: "Location_Updates_Tracking")
        ]);
    SentryId id3 = await Sentry.captureEvent(event3, withScope: (p) {
      //  p.addAttachment(attachment)
    });

    try {
      response = await webService.dio.put(ApiUrl.weatherAlerts,
          data: params.toMap(),
          options: Options(
            headers: {
              ApiHeader.requiresToken.eName: false,
            },
          ));

      final data = response.data;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
