import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

import '../../objections_exports.dart';

class CreateObjection
    extends UseCase<CreateObjectionResponse, CreateObjectionParams> {
  final RequestsRepository repository;
  CreateObjection({required this.repository});
  @override
  Future<Either<Failure, CreateObjectionResponse>> call(
      CreateObjectionParams params) async {
    return await repository.createObjection(params: params);
  }
}
