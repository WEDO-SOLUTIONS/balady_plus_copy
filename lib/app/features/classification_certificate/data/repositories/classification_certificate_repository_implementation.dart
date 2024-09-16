import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/classification_certificate/data/data_source/remote_data_source_implementation.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';

import 'package:dartz/dartz.dart';
import '../../domain/repository/classification_certificate_repository.dart';
import '../model/search_request/search_request_model.dart';

class ClassificationCertificateRepositoryImplementation implements ClassificationCertificateSearchRepository {
  final ClassificationCertificateRemoteDataSource remoteDataSource;

  ClassificationCertificateRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ClassificationCertificateList>>
  searchClassificationCertificate(SearchRequestModel params) async {
    try {
      final data = await remoteDataSource.searchClassificationCertificate(params);
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
