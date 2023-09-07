import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../repositories/repository.dart';

class GetEtmamId extends UseCase<String?, String> {
  final CreateComplianceRepository repository;
  GetEtmamId({required this.repository});
  @override
  Future<Either<Failure, String?>> call(String params) async {
    return await repository.getEtmamId(params: params);
  }
}
