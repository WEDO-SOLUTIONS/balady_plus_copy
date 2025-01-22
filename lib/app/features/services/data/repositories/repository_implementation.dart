import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart' show Failure, CacheFailure;
import '../../services_exports.dart'
    show ServicesLocalDataSource, ServicesRepository;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ServicesRepositoryImplementation implements ServicesRepository {
  final ServicesLocalDataSource localDataSource;

  ServicesRepositoryImplementation({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, HomeServices>> getAllServices() async {
    try {
      final services = await localDataSource.getAllServices();
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
