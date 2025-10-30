import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/data/models/fees_calculator_response_model.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_request.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class CalculatorRepository {
  Future<Either<Failure, FeesCalculatorResponseModel>> calculateFees(
      FeesCalculatorRequest params);
}
