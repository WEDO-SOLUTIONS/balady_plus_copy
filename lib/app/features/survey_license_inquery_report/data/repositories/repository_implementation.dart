import 'package:balady_plus/app/core/errors/errors_exports.dart';

import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entity/survey_inquery_data_entity.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class SurveyInqueryRepositoryImplementation implements SurveyInqueryRepository {
  final SurveyInqueryRemoteDataSource remoteDataSource;

  SurveyInqueryRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<SurveyInqueryData>>> getLicenseData(
      int licenseNumber, String date) async {
    try {

      final data = await remoteDataSource.getLicenseData(licenseNumber, date);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
