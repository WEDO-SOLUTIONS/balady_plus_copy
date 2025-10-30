import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/domain/repositories/repository.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class GetRequestCommercialLicenseDetails
    extends UseCase<RequestCommercialLicenseDetailsModel, int> {
  final RequestCommercialLicenseDetailsRepository repository;

  GetRequestCommercialLicenseDetails({required this.repository});

  @override
  Future<Either<Failure, RequestCommercialLicenseDetailsModel>> call(
      requestId) async {
    return await repository.getRequestCommercialLicenseDetails(requestId);
  }
}
