import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../data/models/ownership_doc_type_response_model.dart';
import '../entities/ownership_doc_type_response.dart';
import '../repositories/repository.dart';

class GetReciptTypes extends UseCase<ComplinaceLookUpResponse, NoParams> {
  final CreateComplianceRepository repository;
  GetReciptTypes({required this.repository});
  @override
  Future<Either<Failure, ComplinaceLookUpResponse>> call(
      NoParams params) async {
    return await repository.getReciptTypes();
  }
}
