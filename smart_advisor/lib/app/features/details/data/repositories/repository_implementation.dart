import '/app/features/details/data/models/entity_violation_activity_details_model.dart';
import '/app/features/details/data/models/entity_violation_activity_model.dart';
import '/app/features/details/data/models/violation_details_vd_model.dart';
import '/app/features/details/domain/entities/entity_activity_details_request_params.dart';
import '/app/features/details/domain/entities/entity_activity_details_response.dart';
import '/app/features/details/domain/entities/entity_violation_activity_details_request_params.dart';
import '/app/features/details/domain/entities/entity_violation_activity_request_params.dart';
import '/app/features/details/domain/entities/regulation_request_params.dart';
import '/app/features/details/domain/entities/regulation_response.dart';
import '/app/features/details/domain/entities/violation_details_Vd_request_params.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class DetailsRepositoryImplementation implements DetailsRepository {
  final DetailsRemoteDataSource remoteDataSource;
  DetailsRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, RegulationResponse>> getRegulations(
      RegulationRequestParams params) async {
    try {
      final data = await remoteDataSource.getRegulations(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, EntityActivityDetailsResponse>> getEntityActivity(
      EntityActivityDetailRequestParams params) async {
    try {
      final data = await remoteDataSource.getEntityActivityDetails(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<EntityViolationActivityModel>>>
      getViolationEntityDetails(
          EntityViolationActivityRequestParams params) async {
    try {
      final data = await remoteDataSource.getEntityViolationActivity(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, EntityViolationActivityDetailsModel>>
      getEntityViolationActivityDetails(
          EntityViolationActivityDetailsRequestParams params) async {
    try {
      final data =
          await remoteDataSource.getEntityViolationActivityDetails(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ViolationDetailsVdModel>>> getEntityViolationDetailsVd(
      ViolationDetailsVdRequestParams params) async {
    try {
      final data = await remoteDataSource.getEntityViolationDetailsVd(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  /* @override
  Future<Either<Failure, ViolationDetailsVdModel>> getViolationEntityDetailsVd(
      ViolationDetailsVdRequestParams params) async {
    try {
      final data = await remoteDataSource.getEntityViolationDetailsVd(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }*/
}
