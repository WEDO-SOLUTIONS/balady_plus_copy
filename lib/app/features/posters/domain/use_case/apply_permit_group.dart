import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/permit_apply_group_request_params.dart';
import '../repositores/repository.dart';

class ApplyPermitLicenseGroup
    extends UseCase<dynamic, PermitApplyGroupRequestParams> {
  final PostersRepository repository;
  ApplyPermitLicenseGroup({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(
      PermitApplyGroupRequestParams params) async {
    return await repository.applyPermitLicenseGroup(params: params);
  }
}
