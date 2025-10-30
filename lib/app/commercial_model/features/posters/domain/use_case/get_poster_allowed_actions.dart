import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/allowed_actions_response.dart';
import '../repositores/repository.dart';

class GetPosterAllowedActions extends UseCase<PosterAllowedAction, int> {
  final PostersRepository repository;
  GetPosterAllowedActions({required this.repository});
  @override
  Future<Either<Failure, PosterAllowedAction>> call(int params) async {
    return await repository.getAllowedActionsOnRequest(params: params);
  }
}
