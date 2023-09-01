import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/ownership_doc_type_response.dart';
import '../repositories/repository.dart';

class GetComplianceSubUsages extends UseCase<ComplinaceLookUpResponse, int> {
  final CreateComplianceRepository repository;
  GetComplianceSubUsages({required this.repository});
  @override
  Future<Either<Failure, ComplinaceLookUpResponse>> call(int params) async {
    return await repository.getSubUsages(mainId: params);
  }
}
