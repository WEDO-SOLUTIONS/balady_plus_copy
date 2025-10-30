import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:dartz/dartz.dart';

abstract class RequestOwnershipTransferDetailsRepository {
  Future<Either<Failure, CommercialLicenceDetails>>
      getRequestOwnershipTransferDetails(
    String commercialLicenseDetailsId,
  );
}

abstract class AcceptOrRejectRequestOwnershipTransferRepository {
  Future<Either<Failure, bool>> acceptCommercialRequestTransfer(
    String commercialLicenseDetailsId,
  );
  Future<Either<Failure, bool>> rejectCommercialRequestTransfer(
    String commercialLicenseDetailsId,
  );
}
