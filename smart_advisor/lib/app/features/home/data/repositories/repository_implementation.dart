import '/app/features/home/home_exports.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

class SmartAdvisorHomeRepositoryImplementation
    implements SmartAdvisorHomeRepository {
  final SmartAdvisorHomeRemoteDataSource remoteDataSource;

  SmartAdvisorHomeRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, NewsResponse>> getNews(NewsParams params) async {
    try {
      final data = await remoteDataSource.getNews(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
