import 'package:dartz/dartz.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../violations_exports.dart';
import '../entities/violation_details_params.dart';

class GetViolationDetails
    extends UseCase<ViolationDetailsEntity, ViolationDetailsParams> {
  final ViolationsRepository repository;
  GetViolationDetails({required this.repository});
  @override
  Future<Either<Failure, ViolationDetailsEntity>> call(
      ViolationDetailsParams params) async {
    return await repository.getViolationDetails(params);
  }
}
