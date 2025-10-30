import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class GetCleanOptions extends UseCase<CleanOptionResponse, int> {
  final CrRepository repository;

  GetCleanOptions({required this.repository});
  @override
  Future<Either<Failure, CleanOptionResponse>> call(int params) async {
    return await repository.getCleanOptions(params: params);
  }
}
