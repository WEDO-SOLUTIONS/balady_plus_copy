import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/ownership_doc_type_response.dart';
import '../repositories/repository.dart';

class GetComplianceMainUsages
    extends UseCase<ComplinaceLookUpResponse, NoParams> {
  final CreateComplianceRepository repository;
  GetComplianceMainUsages({required this.repository});
  @override
  Future<Either<Failure, ComplinaceLookUpResponse>> call(
      NoParams params) async {
    return await repository.getMainUsages();
  }
}
