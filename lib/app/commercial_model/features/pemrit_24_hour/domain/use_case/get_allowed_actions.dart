import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/allowed_actions_response.dart';
import '../repositores/repository.dart';

class GetAllowedActions extends UseCase<Permit24AllowedAction, int> {
  final Permits24Repository repository;
  GetAllowedActions({required this.repository});
  @override
  Future<Either<Failure, Permit24AllowedAction>> call(int params) async {
    return await repository.getPermitAllowedActions(params: params);
  }
}
