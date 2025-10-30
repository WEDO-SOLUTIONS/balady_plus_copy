import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/repository.dart';

class RenewCommercialDraft implements UseCase<String, int> {
  final ManageLicenseRepository repository;

  RenewCommercialDraft(this.repository);

  @override
  Future<Either<Failure, String>> call(int params) async {
    return await repository.renewCommercialLicense(params);
  }
}
