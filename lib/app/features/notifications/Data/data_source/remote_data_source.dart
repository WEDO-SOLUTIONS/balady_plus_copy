import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/search_notifications_params.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../model/noification_response.dart';
import '../model/notification_request.dart';

abstract class NotificationRemoteDataSource {
  Future<ResponseBodyModel<NotificationResponse>> updateNotificationSettings(
      NotificationRequest request);



  //For List Screen
  Future<NotificationsListResponse>
  getNotificationsMessagesList(SearchNotificationsParams request);
}

class NotificationRemoteDataSourceImplementation
    implements NotificationRemoteDataSource {
  final WebService webService;

  NotificationRemoteDataSourceImplementation({required this.webService});

  @override
  Future<ResponseBodyModel<NotificationResponse>> updateNotificationSettings(
      NotificationRequest request) async {
    var response;
    try {
      response = await webService.dio
          .post(ApiUrl.updateNotificationSettings(), data: request.toJson());
      final data = response.data;

      var parsedResult =
          data != null ? NotificationResponse.fromJson(data["data"]) : null;
      final decodedResponse = ResponseBodyModel<NotificationResponse>.fromMap(
          response.data,
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

  @override
  Future<NotificationsListResponse>
      getNotificationsMessagesList(SearchNotificationsParams request) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.notificationsMessagesList,
        data: request.toJson(),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return NotificationsListResponse.fromJson(result);
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
