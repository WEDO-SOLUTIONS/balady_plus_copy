import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/calculate_cost_response_model.dart';
import '../../data/models/permit_request_details_model.dart';
import '../entities/permit_tobacco_caclualte_request.dart';
import '../repositores/repository.dart';

class CalculatePermitTobaccoHourCost extends UseCase<
    CalculateCostPermitTobaccoResponse, PermitTobaccoCalculateRequest> {
  final PermitsTobaccoRepository repository;
  CalculatePermitTobaccoHourCost({required this.repository});
  @override
  Future<Either<Failure, CalculateCostPermitTobaccoResponse>> call(
      PermitTobaccoCalculateRequest params) async {
    return await repository.calculatePermit24HourCost(params: params);
  }
}
