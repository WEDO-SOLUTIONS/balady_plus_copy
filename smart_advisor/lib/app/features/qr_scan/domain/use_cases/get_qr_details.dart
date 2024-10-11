import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/qr_license_details_response_model.dart';
import '../repositories/repository.dart';

class GetQRDataDetails extends UseCase<QrDetailsResponse, String> {
  final QRScanRepository repository;

  GetQRDataDetails({required this.repository});

  @override
  Future<Either<Failure, QrDetailsResponse>> call(String params) async {
    return await repository.getQrData(params);
  }
}
