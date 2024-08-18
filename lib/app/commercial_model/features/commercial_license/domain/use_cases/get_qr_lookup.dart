import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/qr/qr_lookup.dart';

class GetQrLookUp extends UseCase<QrLookUpResponse, String> {
  final CrRepository repository;

  GetQrLookUp({required this.repository});
  @override
  Future<Either<Failure, QrLookUpResponse>> call(String params) async {
    return await repository.getQrLookUp(params: params);
  }
}
