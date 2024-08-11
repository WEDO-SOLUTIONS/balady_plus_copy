import 'package:balady_plus/app/features/vd/domain/entities/categories/category_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/categories/category_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/create_incident/create_incident_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/create_incident/create_incident_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/otp/otp_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/otp/otp_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/special_classifications/special_classifications_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/spl_details/spl_details_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/spl_details/spl_details_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/upload/upload_file_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/upload/upload_file_params.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, VDRemoteDataSource, VDLocalDataSource, SplParams;

import 'package:dartz/dartz.dart' show Either, Left, Right;

import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

import '../../../_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class VDRepositoryImpl implements VDRepository {
  final VDRemoteDataSource remoteDataSource;
  final VDLocalDataSource localDataSource;

  VDRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, CategoriesResponse>> getCategories(
      {required CategoryParams params}) async {
    try {
      final data = await remoteDataSource.getCatgories(params: params);

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

  @override
  Future<Either<Failure, SplResponse>> getSpecialClassifications(
      {required SplParams params}) async {
    try {
      final data =
          await remoteDataSource.getSpecialClassifications(params: params);

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

  @override
  Future<Either<Failure, SPLDetailsResponse>> getSPLDetails(
      {required SPLDetailsParams params}) async {
    try {
      final data = await remoteDataSource.getSPLDetails(params: params);

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

  @override
  Future<Either<Failure, UploadFileResponse>> uploadFile(
      {required UploadFileParams params}) async {
    try {
      final data = await remoteDataSource.uploadFile(params: params);

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

  @override
  Future<Either<Failure, OTPResponse>> getOTP(
      {required OTPParams params}) async {
    try {
      final data = await remoteDataSource.getOTP(params: params);

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

  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createIncidentRegistered({required CreateIncidentParams params}) async {
    try {
      final data =
          await remoteDataSource.createIncidentRegistered(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createIncidentUnRegistered({required CreateIncidentParams params}) async {
    try {
      final data =
          await remoteDataSource.createIncidentUnRegistered(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, bool>> checkCr({required String params}) async {
    // TODO: implement checkCr
    try {
      final data = await remoteDataSource.checkCR(params: params);

      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }
}
