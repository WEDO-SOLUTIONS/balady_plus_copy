import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../entities/request_details_response.dart';
import '../repositories/repository.dart';

class GetRequestDetails extends UseCase<CrmRequestDetails, String> {
  final RequestsRepository repository;

  GetRequestDetails({required this.repository});

  @override
  Future<Either<Failure, CrmRequestDetails>> call(String params) async {
    return await repository.getDCRequestDetails(params);
  }
}
