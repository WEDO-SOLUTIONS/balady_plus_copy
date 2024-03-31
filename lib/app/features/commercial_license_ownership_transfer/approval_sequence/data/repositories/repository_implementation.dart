import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';
import '../models/request_permits_model/permit.dart';
import '../models/request_permits_model/request_permits_model.dart';

class RequestApprovalSequenceRepositoryImplementation
    implements RequestApprovalSequenceRepository {
  final RequestPermitsRemoteDataSource remoteDataSource;

  RequestApprovalSequenceRepositoryImplementation({
    required this.remoteDataSource,
  });
  
  @override
  Future<Either<Failure, List<Permit>?>> getRequestPermits(int requestNumber) async {
    try {
      final data = await remoteDataSource
          .getRequestPermits(requestNumber);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, bool>> saveSelectedRequestPermits(int requestNumber) async {
    try {
      final data = await remoteDataSource
          .saveSelectedRequestPermits(requestNumber);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, bool>> saveShopInfo(int requestNumber) async {
    try {
      final data = await remoteDataSource
          .saveShopInfo(requestNumber);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

    }