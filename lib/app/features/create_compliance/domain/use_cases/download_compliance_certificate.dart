import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../entities/apply_create_compliance_response.dart';
import '../repositories/repository.dart';

class DownloadComplianceCertificate extends UseCase<Uint8List?, String> {
  final CreateComplianceRepository repository;
  DownloadComplianceCertificate({required this.repository});
  @override
  Future<Either<Failure, Uint8List?>> call(String params) async {
    return await repository.downLoadCertificate(params: params);
  }
}
