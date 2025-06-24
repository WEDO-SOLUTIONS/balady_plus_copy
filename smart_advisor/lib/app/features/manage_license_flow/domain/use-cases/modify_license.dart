import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/commercial_license_model.dart';
import '../repositories/repository.dart';

class ModifyCommercialDraft
    implements
        UseCase<String,
            (int id, CommercialLicenseModel commercialLicenseModel)> {
  final ManageLicenseRepository repository;

  ModifyCommercialDraft(this.repository);

  @override
  Future<Either<Failure, String>> call(parma) async {
    return await repository.modifyCommercialLicense(parma.$1, parma.$2);
  }
}
