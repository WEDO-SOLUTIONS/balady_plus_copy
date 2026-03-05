import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/deleted_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/search_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/domain/entities/set_notifications_profile_products_params.dart';
import 'package:balady_plus/app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entities/set_notifications_profile_params.dart';
import '../data_source/notifications_remote_data_source.dart';
import '../model/noification_response.dart';
import '../model/notification_request.dart';
import '../model/notifications_settings_list/notifications_settings_list_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NotificationRepositoryImplementation
    implements
        NotificationsRepository,
        NotificationsListRepository,
        NotificationsSettingsListRepository,
        NotificationsFilterRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<NotificationResponse>>> updateNotificationSettings(
      NotificationRequest request) async {
    try {
      final data = await remoteDataSource.updateNotificationSettings(request);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> markReadNotificationsMessages({required MarkReadNotificationsParams request}) async {
    try {
      final data = await remoteDataSource.markReadNotificationsMessages(request);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> deletedNotificationsMessages({required DeletedNotificationsParams request}) async {
    try {
      final data = await remoteDataSource.deletedNotificationsMessages(request);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  // For Filter Widgets
  @override
  Future<Either<Failure, List<NotificationType>>> getNotificationsProducts() async {
    try {
      final data = await remoteDataSource.getNotificationsProducts();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<NotificationType>>> getNotificationsServicesProducts({required String productId}) async {
    try {
      final data = await remoteDataSource.getNotificationsServicesProducts(productId: productId);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  //For NotificationsListRepository
  @override
  Future<Either<Failure, NotificationsSettingsList>> getNotificationsSettingsList(
      {required String notificationChannelId}) async {
    try {
      final data = await remoteDataSource.getNotificationsSettingsList(notificationChannelId: notificationChannelId);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  //For NotificationsListRepository
  @override
  Future<Either<Failure, bool>> setNotificationsProfile({required SetNotificationsProfileParams params}) async {
    try {
      final data = await remoteDataSource.setNotificationsProfile(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  //For NotificationsListRepository
  @override
  Future<Either<Failure, bool>> setNotificationsProfileProducts(
      {required SetNotificationsProfileProductsParams params}) async {
    try {
      final data = await remoteDataSource.setNotificationsProfileProducts(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
