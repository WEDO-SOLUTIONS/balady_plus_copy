import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/qr_license_details_response_model.dart';
import '../entities/addetional_activites_response.dart';

abstract class QRScanRepository {
  Future<Either<Failure, QrDetailsResponse>> getQrData(String params);
}
