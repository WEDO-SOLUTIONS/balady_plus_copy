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

  @override
  Future<Either<Failure, List<AccommodationTypeEntity>>>
      getAccommodationTypes() async {
    try {
      final data = await remoteDataSource.getAccommodationTypes();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> getConsultationKey(
      ConsultationKeyParamsModel params) async {
    try {
      final data = await remoteDataSource.getConsultationKey(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCivilDefensePredefinedConditions(
      KeyParamsModel params) async {
    try {
      final data =
          await remoteDataSource.getCivilDefensePredefinedConditions(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<CleaningEntity>>> getCleaningMechanisms(
      KeyParamsModel params) async {
    try {
      final data = await remoteDataSource.getCleaningMechanisms(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<CommercialOfficeEntity>>> getCommercialOffices(
      KeyParamsModel params) async {
    try {
      final data = await remoteDataSource.getCommercialOffices(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getIssuingPredefinedConditions() async {
    try {
      final data = await remoteDataSource.getIssuingPredefinedConditions();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LicensePermitEntity>>> getLicensePermits(
      KeyParamsModel params) async {
    try {
      final data = await remoteDataSource.getLicensePermits(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<SupervisingAuthorityEntity>>>
      getSupervisingAuthorities(KeyParamsModel params) async {
    try {
      final data = await remoteDataSource.getSupervisingAuthorities(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveConsultationProgress(
      SaveConsultationProgressParamsModel params) async {
    try {
      final data = await remoteDataSource.saveConsultationProgress(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getLicenseYears(
      GetLicenseYearsParamsModel params) async {
    try {
      final data = await remoteDataSource.getLicenseYears(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveActivities(
      SaveActivitiesParamsModel params) async {
    try {
      final data = await remoteDataSource.saveActivities(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<BoardTypeEntity>>> getBoardTypes() async {
    try {
      final data = await remoteDataSource.getBoardTypes();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, LicenseFeesEntity>> calculateLicenseFees(
      CalculateFeesParamsModel params) async {
    try {
      final data = await remoteDataSource.calculateLicenseFees(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
