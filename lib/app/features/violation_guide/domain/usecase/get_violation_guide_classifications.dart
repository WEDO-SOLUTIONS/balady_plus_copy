import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../vd/domain/entities/gis/gis_params.dart';
import '../../data/models/classification_response.dart';
import '../repository/violation_repository.dart';

class GetViolationGuideClassifications
    extends UseCase<ViolationClassificationResponse, GISParams> {
  final ViolationGuideRepository repository;
  GetViolationGuideClassifications({required this.repository});
  @override
  Future<Either<Failure, ViolationClassificationResponse>> call(
      GISParams params) async {
    return await repository.getViolationsClassifications(params);
  }
}
