import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart' show Failure, CacheFailure;
import '../../services_exports.dart'
    show ServiceEntity, ServicesLocalDataSource, ServicesRepository;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ServicesRepositoryImplementation implements ServicesRepository {
  final ServicesLocalDataSource localDataSource;

  ServicesRepositoryImplementation({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> getEkramServices() async {
    try {
      final services = await localDataSource.getEkramServices();
      return Right(services);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getIslamicServices() async {
    try {
      final services = await localDataSource.getIslamicServices();
      return Right(services);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>>
      getBusinessLicenseServices() async {
    try {
      final services = await localDataSource.getBusinessLicenseServices();
      return Right(services);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getHelpServices() async {
    try {
      final services = await localDataSource.getHelpServices();
      return Right(services);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getMunicipalServices() async {
    try {
      final services = await localDataSource.getMunicipalServices();
      return Right(services);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(CacheFailure());
    }
  }
}
