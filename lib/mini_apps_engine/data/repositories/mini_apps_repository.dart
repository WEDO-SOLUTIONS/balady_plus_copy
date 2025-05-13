
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/mini_apps_engine/data/datasource/events_data_source.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

class MiniAppsRepository {
  final MiniAppsLocalDataSource localDataSource;

  MiniAppsRepository({required this.localDataSource});

  Future<Either<Failure, List<MiniAppModel>>> getMiniAppsList() async {
    late List<MiniAppModel> services;
    try {
      services = await localDataSource.getAllServices();
      return Right(services);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Right(services);
    }
  }
}
