import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/tobacco_services/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/disclosure_request.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/tobacco_schedule.dart';
import 'package:dartz/dartz.dart';

class TobaccoListRepositoryImplementation {
  final TobaccoListRemoteDataSource remoteDataSource;

  TobaccoListRepositoryImplementation({required this.remoteDataSource});

  Future<Either<Failure, List<Facility>>> getUserFacilities() async {
    try {
      final data = await remoteDataSource.getUserFacilities();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  Future<Either<Failure, TobaccoSchedule>> getUserFacilitiesDetails(String registrationNumber) async {
    try {
      final data = await remoteDataSource.getUserFacilitiesDetails(
        registrationNumber,
      );
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  Future<Either<Failure, dynamic>> uploadFile(FileDataItem file) async {
    try {
      final data = await remoteDataSource.uploadFile(file);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  Future<Either<Failure, dynamic>> uploadDisclosure(
      DisclosureRequest disclosureRequest) async {
    try {
      final data =
          await remoteDataSource.uploadDisclosure(disclosureRequest);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
