import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/mini_apps_engine/data/datasource/events_data_source.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MiniAppsRepository {
  final MiniAppsLocalDataSource localDataSource;

  MiniAppsRepository({required this.localDataSource});

  Future<Either<Failure, List<MiniAppModel>>> getMiniAppsList() async {
    late List<MiniAppModel> services;
    try {
      services = await localDataSource.getAllServices();
      return Right(services);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
        ServerFailure(
          error.errorMessage,
          statusCode: 500,
          errorCode: null,
        ),
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
        ServerFailure(
          "errors_server_error_1".tr(),
          statusCode: 500,
          errorCode: null,
        ),
      );
    }
  }

  Future<Either<Failure, String>> getMiniAppAcessToken(String serviceId) async {
    try {
      String accessToken = await localDataSource.getMiniAppAcessToken(serviceId);
      return Right(accessToken);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
        ServerFailure(
          error.errorMessage,
          statusCode: 500,
          errorCode: null,
        ),
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
        ServerFailure(
          "errors_server_error_1".tr(),
          statusCode: 500,
          errorCode: null,
        ),
      );
    }
  }
}
