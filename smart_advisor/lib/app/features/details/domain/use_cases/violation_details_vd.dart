import 'package:smart_advisor/app/features/details/domain/repositories/repository.dart';

import '../../../../core/services/local/use_case.dart';
import '../../data/models/violation_details_vd_model.dart';
import '../entities/violation_details_Vd_request_params.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class GetViolationVDUC
    extends UseCase<List<ViolationDetailsVdModel>, ViolationDetailsVdRequestParams> {
  final DetailsRepository repository;

  GetViolationVDUC({required this.repository});

  @override
  Future<Either<Failure, List<ViolationDetailsVdModel>>> call(
      ViolationDetailsVdRequestParams params) async {
    return await repository.getEntityViolationDetailsVd(params);
  }
}
