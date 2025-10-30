import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dartz/dartz.dart';

abstract class CommercialLicenseDetailsRepository {
  Future<Either<Failure, CommercialLicenceDetails>> getCommercialLicenseDetails(
    int commercialLicenseDetailsId,
  );
}
