import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/models/response_body_model.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class CheckCommercialLicenseDataSource {
  Future<bool> checkCommercialLicense(String licenseId);
}

class CheckCommercialLicesnseDataSourceImpl
    implements CheckCommercialLicenseDataSource {
  final WebService webService;

  CheckCommercialLicesnseDataSourceImpl({required this.webService});
  @override
  Future<bool> checkCommercialLicense(String licenseId) async {
    Response response;
    try {
      response = await webService.dio.get(
        ApiUrl.checkCommercialLicense(licenseId),
      );

      var data = response.data["data"]["result"];

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: data);

      return decodedResponse.data!.result!.toFuture();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }
}
