import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, CategoriesResponse, CategoryParams;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class GetCategories extends UseCase<CategoriesResponse, CategoryParams> {
  final VDRepository repository;

  GetCategories({required this.repository});
  @override
  Future<Either<Failure, CategoriesResponse>> call(
      CategoryParams params) async {
    return await repository.getCategories(params: params);
  }
}
