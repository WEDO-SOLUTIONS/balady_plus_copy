import 'package:smart_advisor/app/features/home_page/data/models/search_isic_model.dart';

import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class SmartAdvisorHomeRepositoryImplementation
    implements SmartAdvisorHomeRepository {
  final SmartAdvisorHomeRemoteDataSource remoteDataSource;
  SmartAdvisorHomeRepositoryImplementation({required this.remoteDataSource});

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
  Future<Either<Failure, List<SearchIsicModel>>> searchIsics(
      String keyword) async {
    try {
      final data = await remoteDataSource.searchIsics(keyword);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
