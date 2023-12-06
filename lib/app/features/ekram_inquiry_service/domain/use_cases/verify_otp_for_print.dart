import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/verify_otp_response.dart';
import '../entities/verify_otp_params.dart';
import '../repositories/ekram_repository.dart';

class VerifyOTPForPrint
    extends UseCase<VerifyOTPResponseModel, VerifyOTPParams> {
  final EkramServicesRepository repository;

  VerifyOTPForPrint({required this.repository});

  @override
  Future<Either<Failure, VerifyOTPResponseModel>> call(
      VerifyOTPParams params) async {
    return await repository.verifyOTPForPrint(params: params);
  }
}
