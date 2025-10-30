import 'package:balady_plus/app/features/balady_calender/data/datasources/balady_calendar_data_source.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/list_events_details.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/filter/filter_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/repositories/balady_calendar_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class BaladyCalendarRepositoryImpl implements BaladyCalendarRepository {
  final BaladyCalendarRemoteDataSource remoteDataSource;
  BaladyCalendarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Filter>> getFilteredEvents() async {
    try {
      final data = await remoteDataSource.getFilteredEvents();
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
  Future<Either<Failure, EventsCountInYears>> getEventsCountInYears(
      {required EventsCommonParams params}) async {
    try {
      final data = await remoteDataSource.getEventsCountInYears(params: params);
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
  Future<Either<Failure, List<MonthsEventsCount>>> getEventsCountInMonths(
      {required EventsCountInMonthsParams params}) async {
    try {
      final data =
          await remoteDataSource.getEventsCountInMonths(params: params);
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
  Future<Either<Failure, EventsDetails>> getEventsDetails(
      {required EventsDetailsParams params}) async {
    try {
      final data = await remoteDataSource.getEventsDetails(params: params);
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
}
