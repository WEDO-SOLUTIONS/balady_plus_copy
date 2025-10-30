import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/find_cemetry_response_model.dart';
import '../entities/find_cemetry_request.dart';
import '../repositories/ekram_repository.dart';

class FindCemetries extends UseCase<FindCemetryResponse, FindCemetryRequest> {
  final EkramServicesRepository repository;

  FindCemetries({required this.repository});

  @override
  Future<Either<Failure, FindCemetryResponse>> call(
      FindCemetryRequest params) async {
    return await repository.findCemetries(params: params);
  }
}
