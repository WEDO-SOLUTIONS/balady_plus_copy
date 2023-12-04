import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/find_cemetry_response_model.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/find_grave_response_model.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/orgnization_charity_list.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/entities/find_cemetry_request.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/entities/find_grave_request.dart';

import 'package:balady_plus/app/features/events/domain/entities/events_category/event_category_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_response.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/ekram_repository.dart';
import '../data_sources/remote_data_source.dart';

class EkramServicesRepositoryImpl implements EkramServicesRepository {
  final EkramServicesRemoteDataSource remoteDataSource;
  EkramServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FindCemetryResponse>> findCemetries(
      {required FindCemetryRequest params}) async {
    try {
      final data = await remoteDataSource.findCemetries(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, FindGraveResponse>> findGraveLocations(
      {required FindGraveRequest params}) async {
    try {
      final data = await remoteDataSource.findGraveLocations(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, EkramCharityOrgnizationResponse>>
      getCharityOrgnizations({required int params}) async {
    try {
      final data =
          await remoteDataSource.getCharityOrgnizations(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getCities() async {
    try {
      final data = await remoteDataSource.getCities();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getDistrcits(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getDistrcits(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getEkramIdentityTypes() async {
    try {
      final data = await remoteDataSource.getEkramIdentityTypes();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }
}
