import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

class CancelObjection extends UseCase<bool, String> {
  final RequestsRepository repository;
  CancelObjection({required this.repository});
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.cancelObjection(params);
  }
}
