import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';
import '../models/qr_license_details_response_model.dart';

class QRScanRepositoryImplementation implements QRScanRepository {
  final QrScanRemoteDataSource remoteDataSource;
  QRScanRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, QrDetailsResponse>> getQrData(String params) async {
    try {
      final data = await remoteDataSource.getQrData(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
