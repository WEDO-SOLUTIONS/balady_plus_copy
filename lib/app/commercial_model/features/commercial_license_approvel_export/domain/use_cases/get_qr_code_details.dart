import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/qr/qr_details.dart';

class GetQrCodeDetails extends UseCase<QrDetails, int> {
  final CrRepository repository;

  GetQrCodeDetails({required this.repository});
  @override
  Future<Either<Failure, QrDetails>> call(int params) async {
    return await repository.getQrCodeDetails(params: params);
  }
}
