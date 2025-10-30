import 'package:smart_advisor/app/features/select_activity/data/models/activity_details_info.dart';
import 'package:smart_advisor/app/features/select_activity/data/models/work_flow_model.dart';

import 'package:smart_advisor/app/features/select_activity/domain/entities/work_flow_request_params.dart';

import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/activity_request_params.dart';
import '/app/features/select_activity/domain/entities/categories_request_params.dart';
import '/app/features/select_activity/domain/entities/isics_request_params.dart';
import '/app/features/select_activity/domain/entities/permit_request_params.dart';
import '/app/features/select_activity/domain/entities/rubrics_request_params.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../domain/entities/addetional_activites_response.dart';
import '../../domain/entities/permits_activites_response.dart';
import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class ActivitesRepositoryImplementation implements ActivitesRepository {
  final ActivitesRemoteDataSource remoteDataSource;
  ActivitesRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AddetionalActivityItem>>> getAddetionalActivites(
      String params) async {
    try {
      final data = await remoteDataSource.getAddetionalActivites(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<PermitItem>>> getPermits(
      PermitRequestParams params) async {
    try {
      final data = await remoteDataSource.getPermits(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, LookUpResponse>> getSectors() async {
    try {
      final data = await remoteDataSource.getSectors();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getcategories(
      CategoriesRequestParams params) async {
    try {
      final data = await remoteDataSource.getCategories(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getRubrics(
      RubricsRequestParams params) async {
    try {
      final data = await remoteDataSource.getRubrics(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getIsics(
      IsicsRequestParams params) async {
    try {
      final data = await remoteDataSource.getIsics(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getActivites(
      ActivityRequestParams params) async {
    try {
      final data = await remoteDataSource.getActivites(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getCities() async {
    try {
      final data = await remoteDataSource.getCities();
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getDistricts(int cityId) async {
    try {
      final data = await remoteDataSource.getDistricts(cityId);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<WorkFlowModel>>> getWorkFlow(
      WorkFlowRequestParams params) async {
    try {
      final data = await remoteDataSource.getWorkFlow(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ActivityDetailsInfo>> getActivityInfo(
      int params) async {
    try {
      final data = await remoteDataSource.getActivityDetailsInfo(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
