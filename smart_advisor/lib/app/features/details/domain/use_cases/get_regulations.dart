import '/app/features/details/domain/entities/regulation_request_params.dart';
import '/app/features/details/domain/entities/regulation_response.dart';
import '/app/features/details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetRegulationsUc
    extends UseCase<RegulationResponse, RegulationRequestParams> {
  final DetailsRepository repository;

  GetRegulationsUc({required this.repository});

  @override
  Future<Either<Failure, RegulationResponse>> call(
      RegulationRequestParams params) async {
    return await repository.getRegulations(params);
  }
}
