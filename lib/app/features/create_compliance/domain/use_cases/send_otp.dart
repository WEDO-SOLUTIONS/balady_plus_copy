import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../entities/send_otp_response.dart';
import '../repositories/repository.dart';

class SendOTP extends UseCase<SendOtpResponse, String> {
  final CreateComplianceRepository repository;
  SendOTP({required this.repository});
  @override
  Future<Either<Failure, SendOtpResponse>> call(String params) async {
    return await repository.sendOTP(params: params);
  }
}
