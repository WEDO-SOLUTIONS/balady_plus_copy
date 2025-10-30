import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../entities/submit_emtithal_request.dart';
import '../repositories/repository.dart';

class SubmitComplianceRequest
    extends UseCase<(String, bool?), (String, SubmitEmtithalRequest)> {
  final CreateComplianceRepository repository;
  SubmitComplianceRequest({required this.repository});
  @override
  Future<Either<Failure, (String, bool?)>> call(
      (String, SubmitEmtithalRequest) params) async {
    return await repository.submitRequest(params.$1, params.$2);
  }
}
