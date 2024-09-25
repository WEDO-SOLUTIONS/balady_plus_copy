import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class SaveAddetionalQrData extends UseCase<int, AddtionalQrDataRequest> {
  final CrRepository repository;

  SaveAddetionalQrData({required this.repository});
  @override
  Future<Either<Failure, int>> call(AddtionalQrDataRequest params) async {
    return await repository.saveAddetionalQrData(params: params);
  }
}
