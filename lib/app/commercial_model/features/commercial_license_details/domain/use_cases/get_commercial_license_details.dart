import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class GetCommercialLicenseDetails
    extends UseCase<CommercialLicenceDetails, int> {
  final CommercialLicenseDetailsRepository repository;

  GetCommercialLicenseDetails({required this.repository});

  @override
  Future<Either<Failure, CommercialLicenceDetails>> call(
      commercialLicenseId) async {
    return await repository.getCommercialLicenseDetails(commercialLicenseId);
  }
}
