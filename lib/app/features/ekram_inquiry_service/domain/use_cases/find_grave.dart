import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/find_grave_response_model.dart';
import '../entities/find_grave_request.dart';
import '../repositories/ekram_repository.dart';

class FindGrave extends UseCase<FindGraveResponse, FindGraveRequest> {
  final EkramServicesRepository repository;

  FindGrave({required this.repository});

  @override
  Future<Either<Failure, FindGraveResponse>> call(
      FindGraveRequest params) async {
    return await repository.findGraveLocations(params: params);
  }
}
