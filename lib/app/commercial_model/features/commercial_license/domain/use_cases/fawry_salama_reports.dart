import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class GetFawrySalamaReports extends UseCase<bool, int> {
  final CrRepository repository;

  GetFawrySalamaReports({required this.repository});
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.fawrySalamaReport(params: params);
  }
}
