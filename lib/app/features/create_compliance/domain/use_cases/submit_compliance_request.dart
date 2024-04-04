import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../repositories/repository.dart';

class SubmitComplianceRequest
    extends UseCase<(String, bool?), (String, String)> {
  final CreateComplianceRepository repository;
  SubmitComplianceRequest({required this.repository});
  @override
  Future<Either<Failure, (String, bool?)>> call((String, String) params) async {
    return await repository.submitRequest(params.$1, params.$2);
  }
}
