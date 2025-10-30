import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/models/download_file_result.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../profile_features/incidents/domain/entities/download_file_params.dart';
import '../../domain/repositories/repository.dart';
import '../data_sources/remote_data_source.dart';

class InvestmentRepositoryImplementation implements InvestmentRepository {
  final RequestsRemoteDataSource remoteDataSource;

  InvestmentRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, DownloadIMSFileResult?>> downloadFile(
      DownLoadFileParams params) async {
    try {
      final data = await remoteDataSource.downloadFile(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
