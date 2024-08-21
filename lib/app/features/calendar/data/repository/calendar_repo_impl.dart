import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/event_category_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';

import 'package:dartz/dartz.dart';

import '../../domain/entities/search_calendar/calendar_details_response.dart';
import '../../domain/entities/search_calendar/search_calendar_params.dart';
import '../../domain/entities/search_calendar/search_calendar_response.dart';
import '../../domain/repository/events_repository.dart';
import '../datasource/calendar_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;
  CalendarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchCalendarResponse>> getSearchEvents(
      {required SearchCalendarParams params}) async {
    try {
      final data = await remoteDataSource.getSearchEvents(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, EventCategoryResponse>> getEventCategory(
      {required EventsCategoryParams params}) async {
    try {
      final data = await remoteDataSource.getEventCategory(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(
        error.errorMessage,
        errorCode: error.errorCode,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, CalendarDetailsResponse>> getEventDetails(
      {required String params}) async {
    try {
      final data = await remoteDataSource.getEventDetails(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }
}
