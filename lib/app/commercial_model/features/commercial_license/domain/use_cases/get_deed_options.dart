import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class GetDeedOptions extends UseCase<List<String>, int> {
  final CrRepository repository;

  GetDeedOptions({required this.repository});
  @override
  Future<Either<Failure, List<String>>> call(int params) async {
    return await repository.getDeedOptions(params: params);
  }
}
