import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class GetRequestCredence extends UseCase<CredenceInfo, int> {
  final CrRepository repository;

  GetRequestCredence({required this.repository});
  @override
  Future<Either<Failure, CredenceInfo>> call(int params) async {
    return await repository.getRequestCredences(params: params);
  }
}
