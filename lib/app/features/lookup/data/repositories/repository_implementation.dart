import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../../../core/utils/utils_exports.dart' show LookupItem;
import '../../lookup_exports.dart'
    show LookupParams, LookupRemoteDataSource, LookupRepository;

class LookupRepositoryImplementation implements LookupRepository {
  final LookupRemoteDataSource remoteDataSource;

  LookupRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LookupItem>>> lookup(LookupParams params) async {
    try {
      final data = await remoteDataSource.lookup(params);
      return Right(data.items);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
