import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/send_otp_response.dart';
import '../entities/send_otp_params.dart';
import '../repositories/ekram_repository.dart';

class SendOTPForPrint extends UseCase<SendOTPResponseModel, SendOTPParams> {
  final EkramServicesRepository repository;

  SendOTPForPrint({required this.repository});

  @override
  Future<Either<Failure, SendOTPResponseModel>> call(
      SendOTPParams params) async {
    return await repository.sendOTPForPrint(params: params);
  }
}
