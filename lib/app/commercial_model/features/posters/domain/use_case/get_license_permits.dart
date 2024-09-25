import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_license_response_model.dart';
import '../entities/permit_licenses_requests_params.dart';
import '../repositores/repository.dart';

class GetLicensePermits
    extends UseCase<PermitsLicensesResponse, PermitLicenseRequestParams> {
  final PostersRepository repository;
  GetLicensePermits({required this.repository});
  @override
  Future<Either<Failure, PermitsLicensesResponse>> call(
      PermitLicenseRequestParams params) async {
    return await repository.getLicensePermits(params: params);
  }
}
