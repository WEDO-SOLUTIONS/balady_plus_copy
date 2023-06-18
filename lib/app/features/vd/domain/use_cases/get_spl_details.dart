import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, SPLDetailsParams, SPLDetailsResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class GetSPLDetails extends UseCase<SPLDetailsResponse, SPLDetailsParams> {
  final VDRepository repository;

  GetSPLDetails({required this.repository});
  @override
  Future<Either<Failure, SPLDetailsResponse>> call(
      SPLDetailsParams params) async {
    return await repository.getSPLDetails(params: params);
  }
}
