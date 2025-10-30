import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../repositores/repository.dart';

class DeletePosterRequest extends UseCase<bool, int> {
  final PostersRepository repository;
  DeletePosterRequest({required this.repository});
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.deletePermitRequest(params: params);
  }
}
