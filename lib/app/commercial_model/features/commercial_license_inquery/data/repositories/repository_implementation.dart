import 'package:balady_plus/app/core/errors/errors_exports.dart';

import 'package:dartz/dartz.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entity/commercial_license_data_entity.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class CommercialLicenseQueryRepositoryImplementation
    implements CommercialLicenseQueryRepository {
  final CommercialLicenseQueryRemoteDataSource remoteDataSource;

  CommercialLicenseQueryRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<CommercialLicenseData>>>
      getCommercialLicenseData(
          int licenseNumber, int unifiedFacilityNumber) async {
    try {
      final data = await remoteDataSource.getCommercialLicenseData(
          licenseNumber, unifiedFacilityNumber);
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
