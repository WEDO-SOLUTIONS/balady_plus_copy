import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/validate_hotel_license.dart';
import '../entities/validate_hotel_license_request.dart';
import '../repositores/repository.dart';

class ValidateTobaccoHotel extends UseCase<PermitTobaccoValidateHotelLicense,
    ValidateHotelLicenseRequest> {
  final PermitsTobaccoRepository repository;
  ValidateTobaccoHotel({required this.repository});
  @override
  Future<Either<Failure, PermitTobaccoValidateHotelLicense>> call(
      ValidateHotelLicenseRequest params) async {
    return await repository.validateHotelLicense(params: params);
  }
}
