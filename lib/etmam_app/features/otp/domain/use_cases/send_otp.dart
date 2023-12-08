import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show OTPRepository, SendOTPResponse, SendOTPParamas;
import '../../../../core/errors/errors_exports.dart' show Failure;

class SendOTP extends UseCase<ApigeeResponse<SendOTPResponse>, SendOTPParamas> {
  final OTPRepository repository;

  SendOTP({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<SendOTPResponse>>> call(
      SendOTPParamas params) async {
    return await repository.sendOTP(params: params);
  }
}
