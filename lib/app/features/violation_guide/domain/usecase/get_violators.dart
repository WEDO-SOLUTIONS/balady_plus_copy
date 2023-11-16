import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/violator_response.dart';
import '../repository/violation_repository.dart';

class GetViolators extends UseCase<ViolatorResponse, NoParams> {
  final ViolationGuideRepository repository;
  GetViolators({required this.repository});
  @override
  Future<Either<Failure, ViolatorResponse>> call(NoParams params) async {
    return await repository.getViolatorsLookUp();
  }
}
