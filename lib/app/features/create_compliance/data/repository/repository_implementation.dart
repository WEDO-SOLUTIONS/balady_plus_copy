import 'package:balady_plus/app/features/create_compliance/data/models/apply_create_compliance_request_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/save_location_compliance_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/apply_create_compliance_response.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/comliance_request_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/repository.dart';
import '../datasource/create_compliance_remote_data_source.dart';

class CreateComplianceRepositoryImplementation
    implements CreateComplianceRepository {
  final CreateComplianceRemoteDataSource remoteDataSource;

  CreateComplianceRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ApplyCreateComplianceResponse>> applyCreateCompliance(
      ApplyCreateComplianceRequest params) async {
    try {
      final data = await remoteDataSource.applyCreateCompliance(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ComplianceRequestDetails>> getComplianceByRequestId(
      String params) async {
    try {
      final data = await remoteDataSource.getComplianceByRequestId(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveLocationCompliance(
      SaveLocationComplianceRequest params) async {
    try {
      final data = await remoteDataSource.saveLocationCompliance(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
