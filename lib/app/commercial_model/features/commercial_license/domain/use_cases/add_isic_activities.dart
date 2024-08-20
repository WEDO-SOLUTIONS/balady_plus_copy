import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class AddIsicActivities extends UseCase<bool, AddIsicActivitiesParams> {
  final CrRepository repository;

  AddIsicActivities({required this.repository});
  @override
  Future<Either<Failure, bool>> call(AddIsicActivitiesParams params) async {
    return await repository.addIsicActivities(params: params);
  }
}
