import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../municipal_advisor_exports.dart';

class MunicipalAdvisorRepositoryImplementation
    implements MunicipalAdvisorRepository {
  final MunicipalAdvisorRemoteDataSource remoteDataSource;

  MunicipalAdvisorRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicActivities() async {
    try {
      final data = await remoteDataSource.getIsicActivities();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicSubActivities(
      IsicSubActivityParamsModel params) async {
    try {
      final data = await remoteDataSource.getIsicSubActivities(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ActivityDetailsEntity>> getActivityDetails(
      ActivityDetailsParamsModel params) async {
    try {
      final data = await remoteDataSource.getActivityDetails(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
