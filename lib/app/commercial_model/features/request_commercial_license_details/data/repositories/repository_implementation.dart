import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RequestCommercialLicenseDetailsRepositoryImplementation
    implements RequestCommercialLicenseDetailsRepository {
  final RequestCommercialLicenseDetailsRemoteDataSource remoteDataSource;

  RequestCommercialLicenseDetailsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, RequestCommercialLicenseDetailsModel>>
      getRequestCommercialLicenseDetails(int commercialLicenseId) async {
    try {
      final data = await remoteDataSource
          .getRequestCommercialLicenseDetails(commercialLicenseId);
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
