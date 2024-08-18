import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_apply_group_response_model.dart';
import '../repositores/repository.dart';

class ApplyPosterLicense extends UseCase<PermitApplyGroupResponse, int> {
  final PostersRepository repository;
  ApplyPosterLicense({required this.repository});
  @override
  Future<Either<Failure, PermitApplyGroupResponse>> call(int params) async {
    return await repository.applyLicense(params: params);
  }
}
