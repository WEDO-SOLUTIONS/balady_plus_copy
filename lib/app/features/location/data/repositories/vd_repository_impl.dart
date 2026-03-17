import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/location/data/data_sources/vd_local_data_source.dart';
import 'package:balady_plus/app/features/location/data/data_sources/vd_remote_data_source.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/repositories/vd_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

class VDRepositoryImpl implements VDRepository {
  final VDRemoteDataSource remoteDataSource;
  final VDLocalDataSource localDataSource;

  VDRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});


  @override
  Future<Either<Failure, GISResponse>> getGISData(
      {required GISParams params}) async {
    try {
      final data = await remoteDataSource.getGISData(params: params);

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
