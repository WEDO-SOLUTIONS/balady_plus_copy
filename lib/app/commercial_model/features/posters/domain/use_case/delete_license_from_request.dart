import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../repositores/repository.dart';

class DeleteLicenseFromRequest extends UseCase<bool, (int, int)> {
  final PostersRepository repository;
  DeleteLicenseFromRequest({required this.repository});
  @override
  Future<Either<Failure, bool>> call((int, int) r) async {
    return await repository.deleteLicenseFromRequest(
        requestId: r.$1, licenseId: r.$2);
  }
}
