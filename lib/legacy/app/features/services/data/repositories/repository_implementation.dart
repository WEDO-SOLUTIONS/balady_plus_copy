import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart' show Failure, CacheFailure;
import '../../services_exports.dart'
    show ServiceEntity, ServicesLocalDataSource, ServicesRepository;

class ServicesRepositoryImplementation implements ServicesRepository {
  final ServicesLocalDataSource localDataSource;

  ServicesRepositoryImplementation({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> getPublicServices() async {
    try {
      final services = await localDataSource.getPublicServices();
      return Right(services);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getMunicipalServices() async {
    try {
      final services = await localDataSource.getMunicipalServices();
      return Right(services);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getNewServices() async {
    try {
      final services = await localDataSource.getNewServices();
      return Right(services);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getImportantServices() async {
    try {
      final services = await localDataSource.getImportantServices();
      return Right(services);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
