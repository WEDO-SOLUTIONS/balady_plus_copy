import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../../vd/domain/entities/create_incident/create_incident_response.dart';
import '../../domain/entities/vehicle_item_params.dart';
import '../../domain/entities/vehicle_response.dart';
import '../../domain/repositories/dc_repository.dart';
import '../data_sources/dc_remote_data_source.dart';
import '../model/create_retrive_car_request.dart';

class DCRetriveRepositoryImpl implements DCRetriveRepository {
  final DCRetriveRemoteDataSource remoteDataSource;

  DCRetriveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<VehicleResponse>>> getMyVehicles(
      {required VehicleItemParams params}) async {
    try {
      final data = await remoteDataSource.getMyVehicles(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createRetriveCar({required CreateRetriveCarRequest params}) async {
    try {
      final data = await remoteDataSource.createRetriveCar(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }
}
