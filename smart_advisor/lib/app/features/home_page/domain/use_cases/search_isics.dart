import '../../data/models/search_isic_model.dart';
import '../repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class SearchIsicsUC extends UseCase<List<SearchIsicModel>, String> {
  final SmartAdvisorHomeRepository repository;

  SearchIsicsUC({required this.repository});

  @override
  Future<Either<Failure, List<SearchIsicModel>>> call(String keyword) async {
    return await repository.searchIsics(keyword);
  }
}
