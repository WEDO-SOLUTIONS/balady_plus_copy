import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/data/models/fees_calculator_response_model.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_request.dart';

import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class CalculatorRepositoryImplementation implements CalculatorRepository {
  final CalculatorRemoteDataSource remoteDataSource;
  CalculatorRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, FeesCalculatorResponseModel>> calculateFees(
      FeesCalculatorRequest params) async {
    try {
      final data = await remoteDataSource.calculateFees(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
