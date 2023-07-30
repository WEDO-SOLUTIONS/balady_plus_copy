import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/request_details_response.dart';
import '../repositories/repository.dart';

class GetMsrDetails extends UseCase<RequestDetailsResponse, String> {
  final RequestsRepository repository;

  GetMsrDetails({required this.repository});

  @override
  Future<Either<Failure, RequestDetailsResponse>> call(String params) async {
    return await repository.getCRMREQRequestDetails(params);
  }
}
