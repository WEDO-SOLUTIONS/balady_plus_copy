import 'package:smart_advisor/app/features/map/data/models/map_requests_params.dart';

import 'package:smart_advisor/app/features/map/data/models/point_layers_data.dart';

import '/app/features/map/domain/entities/get_zones_request.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/gis_data_response.dart';
import '/app/features/map/domain/entities/validate_point_request.dart';
import '/app/features/map/domain/entities/validate_point_response.dart';
import '/app/features/map/domain/entities/zone_item.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class SmartAdvisorMapRepositoryImplementation
    implements SmartAdvisorMapRepository {
  final SmartAdvisorMapRemoteDataSource remoteDataSource;
  SmartAdvisorMapRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, GisDataResponse>> getGISData(
      GISDataRequest params) async {
    try {
      final data = await remoteDataSource.getGISData(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ZoneItem>>> getZones(
      GetZonesRequest params) async {
    try {
      final data = await remoteDataSource.getZones(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ValidatePointResponse>>> validatePoint(
      ValidatePointRequest params) async {
    try {
      final data = await remoteDataSource.validatePoint(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<PointLayersData>?>> getPointsInLayers(
      MapRequestParams params) async {
    try {
      final data = await remoteDataSource.getPointsInLayers(params: params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
