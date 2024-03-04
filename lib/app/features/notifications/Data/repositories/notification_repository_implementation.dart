import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/Data/model/notifications_list/search_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/domain/repositories/notification_repository.dart';

import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../data_source/remote_data_source.dart';
import '../model/noification_response.dart';
import '../model/notification_request.dart';


class NotificationRepositoryImplementation implements NotificationsRepository, NotificationsListRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<NotificationResponse>>> updateNotificationSettings( NotificationRequest request) async {
    try {
      final data = await remoteDataSource.updateNotificationSettings(request);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }







  //For NotificationsListRepository
  @override
  Future<Either<Failure, NotificationsListResponse>> getNotificationsMessagesList(
      {required SearchNotificationsParams request}) async {
    try {
      final data = await remoteDataSource.getNotificationsMessagesList(request);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }



}
