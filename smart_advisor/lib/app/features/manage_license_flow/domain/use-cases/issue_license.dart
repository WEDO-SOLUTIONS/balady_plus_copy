import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/commercial_license_model.dart';
import '../repositories/repository.dart';

class IssueCommercialDraft implements UseCase<String, CommercialLicenseModel> {
  final ManageLicenseRepository repository;

  IssueCommercialDraft(this.repository);

  @override
  Future<Either<Failure, String>> call(CommercialLicenseModel params) async {
    return await repository.issueLicenseCommercial(params);
  }
}
