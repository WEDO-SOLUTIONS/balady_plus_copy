import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, SplParams, SplResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class GetSpecialClassifications extends UseCase<SplResponse, SplParams> {
  final VDRepository repository;

  GetSpecialClassifications({required this.repository});
  @override
  Future<Either<Failure, SplResponse>> call(SplParams params) async {
    return await repository.getSpecialClassifications(params: params);
  }
}
