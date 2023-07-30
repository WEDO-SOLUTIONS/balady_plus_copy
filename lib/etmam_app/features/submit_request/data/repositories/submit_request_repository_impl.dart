import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_response.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart'
    show
        SubmitRequestRepository,
        SubmitRequestRemoteDataSource,
        SubmitRequestLocalDataSource;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

class SubmitRequestRepositoryImpl implements SubmitRequestRepository {
  final SubmitRequestRemoteDataSource remoteDataSource;
  final SubmitRequestLocalDataSource localDataSource;

  SubmitRequestRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<SubmitRespone>>> submitRequest(
      {required SubmitParams params}) async {
    try {
      final data = await remoteDataSource.submitRequest(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
