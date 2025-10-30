import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../repositories/repository.dart';

class DeleteComplianceRequest extends UseCase<bool?, String> {
  final CreateComplianceRepository repository;
  DeleteComplianceRequest({required this.repository});
  @override
  Future<Either<Failure, bool?>> call(String params) async {
    return await repository.deleteComplianeRequeest(params: params);
  }
}
