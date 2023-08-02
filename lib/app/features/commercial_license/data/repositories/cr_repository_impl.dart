import 'package:dartz/dartz.dart' show Either, Left, Right;
import '../../../../core/errors/errors_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';

class CrRepositoryImpl implements CrRepository {
  final CrRemoteDataSource remoteDataSource;

  CrRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<RecordInfo>>> getRecordInfo(
      {required String crNumber}) async {
    try {
      final data = await remoteDataSource.getRecordInfo(crNumber: crNumber);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, List<SubActivityEntity>>> getSubActivities(
      {required String isicCode}) async {
    try {
      final data = await remoteDataSource.getSubActivities(isicCode: isicCode);

      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }
}
