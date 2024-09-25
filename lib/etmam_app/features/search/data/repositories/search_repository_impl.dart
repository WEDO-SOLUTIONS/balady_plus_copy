import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/search/domain/entities/search_params.dart';
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show
        SearchRemoteDataSource,
        SearchLocalDataSource,
        SearchRepository,
        SearchResponse;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  Future<Either<Failure, ApigeeResponse<SearchResponse>>> getSearchData(
      {required SearchParams params}) async {
    try {
      final data = await remoteDataSource.getSearchData(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
