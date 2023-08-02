import 'package:dartz/dartz.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../violations_exports.dart';

class GetViolationDetails extends UseCase<ViolationDetailsEntity, String> {
  final ViolationsRepository repository;
  GetViolationDetails({required this.repository});
  @override
  Future<Either<Failure, ViolationDetailsEntity>> call(String params) async {
    return await repository.getViolationDetails(params);
  }
}
