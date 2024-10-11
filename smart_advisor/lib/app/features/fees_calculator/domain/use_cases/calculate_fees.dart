import '/app/features/fees_calculator/data/models/fees_calculator_response_model.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_request.dart';
import '/app/features/fees_calculator/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class CalculateFeesUC
    extends UseCase<FeesCalculatorResponseModel, FeesCalculatorRequest> {
  final CalculatorRepository repository;

  CalculateFeesUC({required this.repository});

  @override
  Future<Either<Failure, FeesCalculatorResponseModel>> call(
      FeesCalculatorRequest request) async {
    return await repository.calculateFees(request);
  }
}
