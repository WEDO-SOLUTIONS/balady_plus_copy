import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

// class GetRequestOwnershipTransferDetails extends UseCase<CommercialLicenceDetails,String> {
//   final RequestOwnershipTransferDetailsRepository repository;

//   GetRequestOwnershipTransferDetails({required this.repository});

//   @override
//   Future<Either<Failure, CommercialLicenceDetails>> call(params) async {
//     return await repository.getRequestOwnershipTransferDetails(params);
//   }
// }
