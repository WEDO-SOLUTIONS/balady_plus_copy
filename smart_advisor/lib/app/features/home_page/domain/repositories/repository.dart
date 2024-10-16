import '../../data/models/search_isic_model.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class SmartAdvisorHomeRepository {
  Future<Either<Failure, LookUpResponse>> getSectors();

  Future<Either<Failure, List<SearchIsicModel>>> searchIsics(String keyword);
}
