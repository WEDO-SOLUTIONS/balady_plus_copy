import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

import '../../objections_exports.dart';
import '../entities/validate_objection_params.dart';

class ValidateObjectableTransaction
    extends UseCase<bool, ValidateObjectionParams> {
  final RequestsRepository repository;
  ValidateObjectableTransaction({required this.repository});
  @override
  Future<Either<Failure, bool>> call(ValidateObjectionParams params) async {
    return await repository.validateObjectableTransaction(params);
  }
}
