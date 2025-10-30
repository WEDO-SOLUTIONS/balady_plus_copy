import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:dartz/dartz.dart';

abstract class RequestCommercialLicenseDetailsRepository {
  Future<Either<Failure, RequestCommercialLicenseDetailsModel>>
      getRequestCommercialLicenseDetails(
    int requestId,
  );
}
