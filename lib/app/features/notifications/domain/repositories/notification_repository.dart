import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/notifications/Data/model/noification_response.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notification_request.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/search_notifications_params.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, ResponseBodyModel<NotificationResponse>>>
      updateNotificationSettings(NotificationRequest request);
}


//For List Screen
abstract class NotificationsListRepository {
  Future<Either<Failure, NotificationsListResponse>> getNotificationsMessagesList(
      {required SearchNotificationsParams request});
}