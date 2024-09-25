import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/violation_guide/data/models/classification_response.dart';
import 'package:balady_plus/app/features/violation_guide/data/models/establishment_size_response.dart';
import 'package:balady_plus/app/features/violation_guide/data/models/regualation_cluses_details.dart';
import 'package:balady_plus/app/features/violation_guide/data/models/regulation_clause_response.dart';
import 'package:balady_plus/app/features/violation_guide/data/models/violator_response.dart';
import 'package:balady_plus/app/features/violation_guide/domain/entites/regulation_clauses_details_params.dart';
import 'package:balady_plus/app/features/violation_guide/domain/entites/regulation_clauses_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/repository/violation_repository.dart';
import '../datasource/violation_remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ViolationGuideRepositoryImplementation
    implements ViolationGuideRepository {
  final ViolationGuideRemoteDataSource remoteDataSource;

  ViolationGuideRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, EstablishmentSizeResponse>>
      getEstablishmentSize() async {
    try {
      final data = await remoteDataSource.getEstablishmentSize();
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
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, RegulationClausesResponse>>
      getRegulationClausesResponse(RegulationClausesParams params) async {
    try {
      final data = await remoteDataSource.getRegulationClausesResponse(params);
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
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ViolationClassificationResponse>>
      getViolationsClassifications(GISParams params) async {
    try {
      final data = await remoteDataSource.getViolationsClassifications(params);
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
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ViolatorResponse>> getViolatorsLookUp() async {
    try {
      final data = await remoteDataSource.getViolatorsLookUp();
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
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, RegulationClauseDetails>> getRegulationDetails(
      RegulationClauseDetailsParams params) async {
    try {
      final data = await remoteDataSource.getRegulationDetails(params: params);
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
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
