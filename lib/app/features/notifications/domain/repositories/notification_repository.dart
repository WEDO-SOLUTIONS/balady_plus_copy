import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/notifications/data/model/noification_response.dart';
import 'package:balady_plus/app/features/notifications/data/model/notification_request.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/deleted_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/search_notifications_params.dart';
import 'package:dartz/dartz.dart';

import '../../data/model/notifications_settings_list/notifications_settings_list_response.dart';
import '../entities/set_notifications_profile_params.dart';
import '../entities/set_notifications_profile_products_params.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, ResponseBodyModel<NotificationResponse>>>
      updateNotificationSettings(NotificationRequest request);
}

//For List Screen
abstract class NotificationsListRepository {
  Future<Either<Failure, NotificationsListResponse>>
      getNotificationsMessagesList(
          {required SearchNotificationsParams request});

  Future<Either<Failure, bool>>
  markReadNotificationsMessages(
      {required MarkReadNotificationsParams request});

  Future<Either<Failure, bool>>
  deletedNotificationsMessages(
      {required DeletedNotificationsParams request});
}


abstract class NotificationsSettingsListRepository {
  Future<Either<Failure, NotificationsSettingsList>>
      getNotificationsSettingsList(
          {required String notificationChannelId});
}
abstract class NotificationsProfileRepository {
  Future<Either<Failure, int>>
      setNotificationsProfile(
          {required SetNotificationsProfileParams params});
}
abstract class NotificationsProfileProductsRepository {
  Future<Either<Failure, int>>
      setNotificationsProfileProducts(
          {required SetNotificationsProfileProductsParams params});
}
