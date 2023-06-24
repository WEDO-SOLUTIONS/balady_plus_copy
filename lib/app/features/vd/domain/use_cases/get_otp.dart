import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, OTPResponse, OTPParams;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class GetOTP extends UseCase<OTPResponse, OTPParams> {
  final VDRepository repository;

  GetOTP({required this.repository});
  @override
  Future<Either<Failure, OTPResponse>> call(OTPParams params) async {
    return await repository.getOTP(params: params);
  }
}
