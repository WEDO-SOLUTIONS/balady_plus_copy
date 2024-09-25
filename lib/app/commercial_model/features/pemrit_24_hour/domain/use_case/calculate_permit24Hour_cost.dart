import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/calculate_cost_response_model.dart';
import '../../data/models/permit_request_details_model.dart';
import '../repositores/repository.dart';

class CalculatePermit24HourCost
    extends UseCase<CalculateCost24PermitResponse, int> {
  final Permits24Repository repository;
  CalculatePermit24HourCost({required this.repository});
  @override
  Future<Either<Failure, CalculateCost24PermitResponse>> call(
      int params) async {
    return await repository.calculatePermit24HourCost(params: params);
  }
}
