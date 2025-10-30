import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class SaveActivityDetails extends UseCase<int, SubmitActivityDetailRequest> {
  final CrRepository repository;

  SaveActivityDetails({required this.repository});
  @override
  Future<Either<Failure, int>> call(SubmitActivityDetailRequest params) async {
    return await repository.saveActivityDetails(params);
  }
}
