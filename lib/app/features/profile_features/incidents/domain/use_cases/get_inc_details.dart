import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../data/models/request_details_response.dart';
import '../repositories/repository.dart';

class GetIncDetails extends UseCase<RequestDetailsResponse, String> {
  final RequestsRepository repository;

  GetIncDetails({required this.repository});

  @override
  Future<Either<Failure, RequestDetailsResponse>> call(String params) async {
    return await repository.getCRMIncidentRequestDetails(params);
  }
}
