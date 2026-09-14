import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/deleted_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/search_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_settings_list/notifications_settings_list_response.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;
import '../../domain/entities/set_notifications_profile_params.dart';
import '../../domain/entities/set_notifications_profile_products_params.dart';
import '../model/noification_response.dart';
import '../model/notification_request.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class NotificationsRemoteDataSource {
  Future<ResponseBodyModel<NotificationResponse>> updateNotificationSettings(NotificationRequest request);

  //For List Screen
  Future<NotificationsListResponse> getNotificationsMessagesList(SearchNotificationsParams request);

  Future<bool> markReadNotificationsMessages(MarkReadNotificationsParams request);

  Future<bool> deletedNotificationsMessages(DeletedNotificationsParams request);

  //For List Screen
  Future<List<NotificationType>> getNotificationsProducts();

  Future<List<NotificationType>> getNotificationsServicesProducts({required String productId});

  //Notifications settings list
  Future<NotificationsSettingsList> getNotificationsSettingsList({required String notificationChannelId});

  Future<bool> setNotificationsProfile({required SetNotificationsProfileParams params});

  Future<bool> setNotificationsProfileProducts({required SetNotificationsProfileProductsParams params});
}

class NotificationRemoteDataSourceImplementation implements NotificationsRemoteDataSource {
  final WebService webService;

  final Map<String, dynamic> dataHeaders = {
    "x-actor-type-id": "user",
    "x-actor-context-id": "beneficiaries",
    "x-platform-id": "super-app",
    "x-channel-id": "mobile",
    "notification-channel-id": "mobile",
  };

  NotificationRemoteDataSourceImplementation({required this.webService});

  @override
  Future<ResponseBodyModel<NotificationResponse>> updateNotificationSettings(NotificationRequest request) async {
    Response? response;
    try {
      response = await webService.dio.post(ApiUrl.updateNotificationSettings(), data: request.toJson());
      final data = response.data;

      var parsedResult = data != null ? NotificationResponse.fromJson(data["data"]) : null;
      final decodedResponse = ResponseBodyModel<NotificationResponse>.fromMap(
        response.data,
        parsedResult: parsedResult,
      );

      return decodedResponse.toFuture();

      // final result = ResponseBodyModel.fromMap(data).data?.result;
      // CommercialLicenseDataModel commercialLicencedata = CommercialLicenseDataModel.fromJson(result!);
      // return  commercialLicencedata;
    } on DioException catch (error, stackTrace) {
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
      throw ServerException(error.toString(), statusCode: error.response?.statusCode, dioError: error);
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
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }

  //Notifications settings list
  @override
  Future<NotificationsListResponse> getNotificationsMessagesList(SearchNotificationsParams request) async {
    Response? response;
    try {
      dataHeaders.addAll(request.persoana);
      dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
      response = await webService.dio.get(
        ApiUrl.notificationsMessagesList,
        queryParameters: request.toJsonQueryParameters(),
        options: Options(headers: dataHeaders),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return NotificationsListResponse.fromJson(result);
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<bool> markReadNotificationsMessages(MarkReadNotificationsParams request) async {
    Response? response;
    try {
      dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
      dataHeaders['x-platform-id'] = "super-app";
      dataHeaders['x-channel-id'] = "mobile";
      dataHeaders['x-actor-type-id'] = "user";
      response = await webService.dio.put(
        ApiUrl.notificationsMarkRead,
        data: request.toJson(),
        options: Options(headers: dataHeaders),
      );
      return true;
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<bool> deletedNotificationsMessages(DeletedNotificationsParams request) async {
    Response? response;
    try {
      dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
      response = await webService.dio.delete(
        ApiUrl.notificationsDeletedMessages,
        data: request.toJson(),
        options: Options(headers: dataHeaders),
      );
      return true;
    } on DioException catch (error, stackTrace) {
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

  //Notifications settings list
  @override
  Future<List<NotificationType>> getNotificationsProducts() async {
    Response? response;
    try {
      dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
      response = await webService.dio.get(
        ApiUrl.notificationsProducts,
        queryParameters: {"notification-channel-id": "mobile", "app-id": "super-app"},
        options: Options(headers: dataHeaders),
      );
      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result.map((e) => NotificationType.fromJson(e)).toList();
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<List<NotificationType>> getNotificationsServicesProducts({required String productId}) async {
    Response? response;
    try {
      dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
      response = await webService.dio.get(
        ApiUrl.notificationsServices,
        queryParameters: {'product-id': productId, "notification-channel-id": "mobile", "app-id": "super-app"},
        // data: request.toJson(),
        options: Options(headers: dataHeaders),
      );
      final data = response.data;
      final List result = ResponseBodyModel.fromMap(data).data?.result;
      return result.map((e) => NotificationType.fromJson(e)).toList();
    } on DioException catch (error, stackTrace) {
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

  @override
  Future<NotificationsSettingsList> getNotificationsSettingsList({required String notificationChannelId}) async {
    Response? response;
    dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
    try {
      response = await webService.dio.get(
        ApiUrl.notificationsSettingsList,
        queryParameters: {'notification-channel-id': notificationChannelId},
        options: Options(headers: dataHeaders),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return NotificationsSettingsList.fromJson(result);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

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

  @override
  Future<bool> setNotificationsProfile({required SetNotificationsProfileParams params}) async {
    dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
    Response? response;
    try {
      response = await webService.dio.post(
        ApiUrl.setProfileNotificationsSettings,
        data: params.toJson(),
        options: Options(headers: dataHeaders),
      );
      return response.statusCode == 200 ? true : false;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

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

  @override
  Future<bool> setNotificationsProfileProducts({required SetNotificationsProfileProductsParams params}) async {
    dataHeaders['x-correlation-id'] = CommonFunctions.generateGUID();
    dataHeaders['Accept'] = "*/*";
    Response? response;
    try {
      response = await webService.dio.post(
        ApiUrl.setProductsNotificationsSettings,
        data: params.toJson(),
        options: Options(headers: dataHeaders),
      );
      return response.statusCode == 200 ? true : false;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }

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
