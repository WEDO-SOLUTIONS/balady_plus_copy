import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/qr/qr_submit_response.dart';

class SubmitQR extends UseCase<QrSubmitResponse, int> {
  final CrRepository repository;

  SubmitQR({required this.repository});
  @override
  Future<Either<Failure, QrSubmitResponse>> call(int params) async {
    return await repository.qrSubmit(params: params);
  }
}
