import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/deleted_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/search_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_settings_list/notifications_settings_list_response.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../../domain/entities/set_notifications_profile_params.dart';
import '../../domain/entities/set_notifications_profile_products_params.dart';
import '../model/noification_response.dart';
import '../model/notification_request.dart';

abstract class NotificationsRemoteDataSource {
  Future<ResponseBodyModel<NotificationResponse>> updateNotificationSettings(
      NotificationRequest request);

  //For List Screen
  Future<NotificationsListResponse> getNotificationsMessagesList(
      SearchNotificationsParams request);
  Future<bool> markReadNotificationsMessages(MarkReadNotificationsParams request);
  Future<bool> deletedNotificationsMessages(DeletedNotificationsParams request);

  //Notifications settings list
  Future<NotificationsSettingsList> getNotificationsSettingsList(
      {required String notificationChannelId});

  Future<int> setNotificationsProfile(
      {required SetNotificationsProfileParams params});

  Future<int> setNotificationsProfileProducts(
      {required SetNotificationsProfileProductsParams params});
}

class NotificationRemoteDataSourceImplementation
    implements NotificationsRemoteDataSource {
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

  //Notifications settings list
  @override
  Future<NotificationsListResponse> getNotificationsMessagesList(
      SearchNotificationsParams request) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.notificationsMessagesList,
        queryParameters: request.toJson(),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return NotificationsListResponse.fromJson(result);
    } on DioException catch (error) {
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
  @override
  Future<bool> markReadNotificationsMessages(
      MarkReadNotificationsParams request) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.notificationsMessagesList,
        queryParameters: request.toJson(),
      );
      return true;
    } on DioException catch (error) {
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
  @override
  Future<bool> deletedNotificationsMessages(DeletedNotificationsParams request) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.notificationsMessagesList,
        queryParameters: request.toJson(),
      );
      return true;
    } on DioException catch (error) {
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

  @override
  Future<NotificationsSettingsList> getNotificationsSettingsList(
      {required String notificationChannelId}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.notificationsSettingsList,
        queryParameters: {'notification-channel-id': notificationChannelId},
      );
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return NotificationsSettingsList.fromJson(result);
    } on DioException catch (error) {
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

  @override
  Future<int> setNotificationsProfile(
      {required SetNotificationsProfileParams params}) async {
    Response? response;

    try {
      response = await webService.dio.post(
        ApiUrl.setProfileNotificationsSettings,
        queryParameters: params.toJson(),
      );
      return response.statusCode!;
    } on DioException catch (error) {
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

  @override
  Future<int> setNotificationsProfileProducts(
      {required SetNotificationsProfileProductsParams params}) async {
    Response? response;

    try {
      response = await webService.dio.post(
        ApiUrl.setProductsNotificationsSettings,
        queryParameters: params.toJson(),
      );
      return response.statusCode!;
    } on DioException catch (error) {
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
