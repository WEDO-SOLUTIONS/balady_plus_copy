import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/qr/qr_lookup_model.dart';

class GetQrLookUp extends UseCase<QrLookUpResponseModel, String> {
  final Repository repository;

  GetQrLookUp({required this.repository});
  @override
  Future<Either<Failure, QrLookUpResponseModel>> call(String params) async {
    return await repository.getQrLookUp(params: params);
  }
}
