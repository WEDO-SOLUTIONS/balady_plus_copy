import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show OTPRepository, OTPVerifyParamas;
import '../../../../core/errors/errors_exports.dart' show Failure;

class VerifyOTP extends UseCase<ApigeeResponse, OTPVerifyParamas> {
  final OTPRepository repository;

  VerifyOTP({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse>> call(OTPVerifyParamas params) async {
    return await repository.verifyOTP(params: params);
  }
}
