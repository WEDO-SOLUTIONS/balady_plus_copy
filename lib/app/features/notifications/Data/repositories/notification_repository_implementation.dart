import 'package:balady_plus/app/core/errors/errors_exports.dart';

import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../data_source/remote_data_source.dart';
import '../model/noification_response.dart';
import '../model/notification_request.dart';


class NotificationRepositoryImplementation {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImplementation({
    required this.remoteDataSource,
  });

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



}
