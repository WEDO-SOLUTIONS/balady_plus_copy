import 'package:balady_plus/app/features/vd/vd_exports.dart' show VDRepository;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class CheckCR extends UseCase<bool, String> {
  final VDRepository repository;

  CheckCR({required this.repository});
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.checkCr(params: params);
  }
}
