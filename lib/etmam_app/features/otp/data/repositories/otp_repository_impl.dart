import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse;

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show
        OTPLocalDataSource,
        OTPRemoteDataSource,
        OTPRepository,
        OTPVerifyParamas,
        SendOTPParamas,
        SendOTPResponse;
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class OTPRepositoryImpl implements OTPRepository {
  final OTPRemoteDataSource remoteDataSource;
  final OTPLocalDataSource localDataSource;

  OTPRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<SendOTPResponse>>> sendOTP(
      {required SendOTPParamas params}) async {
    try {
      final data = await remoteDataSource.sendOTP(params: params);

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
  Future<Either<Failure, ApigeeResponse>> verifyOTP(
      {required OTPVerifyParamas params}) async {
    try {
      final data = await remoteDataSource.verifyOTP(params: params);

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
