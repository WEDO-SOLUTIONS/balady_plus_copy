import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

class GetObjectablePermit extends UseCase<String, String> {
  final RequestsRepository repository;
  GetObjectablePermit({required this.repository});
  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.getPermitURL(params);
  }
}
