import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../entities/verifiy_salama_requst.dart';

class ValidateSalamaBill extends UseCase<bool, VerifySalamaRequest> {
  final CrRepository repository;

  ValidateSalamaBill({required this.repository});
  @override
  Future<Either<Failure, bool>> call(VerifySalamaRequest params) async {
    return await repository.validateSalamaBill(params: params);
  }
}
