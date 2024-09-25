import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../entities/verifiy_salama_requst.dart';

class ValidateSalamaBill extends UseCase<dynamic, VerifySalamaRequest> {
  final CrRepository repository;

  ValidateSalamaBill({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(VerifySalamaRequest params) async {
    return await repository.validateSalamaBill(params: params);
  }
}
