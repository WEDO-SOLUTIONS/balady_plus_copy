import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/find_cemetry_response_model.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/find_grave_response_model.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/orgnization_charity_list.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/send_otp_response.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/data/models/verify_otp_response.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/entities/find_cemetry_request.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/entities/find_grave_request.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/entities/send_otp_params.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/entities/verify_otp_params.dart';

import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/ekram_repository.dart';
import '../data_sources/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class EkramServicesRepositoryImpl implements EkramServicesRepository {
  final EkramServicesRemoteDataSource remoteDataSource;
  EkramServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FindCemetryResponse>> findCemetries(
      {required FindCemetryRequest params}) async {
    try {
      final data = await remoteDataSource.findCemetries(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, FindGraveResponse>> findGraveLocations(
      {required FindGraveRequest params}) async {
    try {
      final data = await remoteDataSource.findGraveLocations(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, EkramCharityOrgnizationResponse>>
      getCharityOrgnizations({required int params}) async {
    try {
      final data =
          await remoteDataSource.getCharityOrgnizations(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getCities() async {
    try {
      final data = await remoteDataSource.getCities();
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getDistrcits(
      {required int params}) async {
    try {
      final data = await remoteDataSource.getDistrcits(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LookUpItem>>> getEkramIdentityTypes() async {
    try {
      final data = await remoteDataSource.getEkramIdentityTypes();
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, SendOTPResponseModel>> sendOTPForPrint(
      {required SendOTPParams params}) async {
    try {
      final data = await remoteDataSource.sendOTPForPrint(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, VerifyOTPResponseModel>> verifyOTPForPrint(
      {required VerifyOTPParams params}) async {
    try {
      final data = await remoteDataSource.verifyOTPForPrint(params: params);
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
      return Left(ServerFailure(
        error.errorMessage,
        statusCode: error.statusCode,
      ));
    }
  }
}
