import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/apply_create_compliance_request_model.dart';
import '../entities/apply_create_compliance_response.dart';
import '../entities/verify_otp_request.dart';
import '../repositories/repository.dart';

class VerifyOTP extends UseCase<bool, VerifyOTPRequest> {
  final CreateComplianceRepository repository;
  VerifyOTP({required this.repository});
  @override
  Future<Either<Failure, bool>> call(VerifyOTPRequest params) async {
    return await repository.verifyOTP(params: params);
  }
}
