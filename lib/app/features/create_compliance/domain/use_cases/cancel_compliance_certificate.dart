import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../repositories/repository.dart';

class CancelComplianceCertificate extends UseCase<bool, int> {
  final CreateComplianceRepository repository;
  CancelComplianceCertificate({required this.repository});
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.cancelComplianceCertificate(params);
  }
}
