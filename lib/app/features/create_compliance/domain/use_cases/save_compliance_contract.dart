import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/save_contract_info_request.dart';
import '../repositories/repository.dart';

class SaveContractCompliance extends UseCase<bool, SaveContractInfoRequest> {
  final CreateComplianceRepository repository;
  SaveContractCompliance({required this.repository});
  @override
  Future<Either<Failure, bool>> call(SaveContractInfoRequest params) async {
    return await repository.saveContractInfo(params);
  }
}
