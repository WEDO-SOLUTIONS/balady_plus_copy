import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show SendOTPResponse, SendOTPParamas, OTPVerifyParamas;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class OTPRepository {
  Future<Either<Failure, ApigeeResponse<SendOTPResponse>>> sendOTP(
      {required SendOTPParamas params});
  Future<Either<Failure, ApigeeResponse>> verifyOTP(
      {required OTPVerifyParamas params});
}
