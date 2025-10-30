import 'package:smart_advisor/app/features/self_rating/domain/entities/submit_rating_request.dart';

import '../models/rating_items_response.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/data/models/fees_calculator_response_model.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_request.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class RepositoryImplementation implements Repository {
  final RemoteDataSource remoteDataSource;
  RepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, RatingItemsResponseModel>> getRatingItems(
      int params) async {
    try {
      final data = await remoteDataSource.getRatingItems(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, double>> submitRatingItems(
      SubmitRatingRequest params) async {
    try {
      final data = await remoteDataSource.submitRatingItems(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
