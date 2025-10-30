import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/categories_request_params.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetCategoriesUc
    extends UseCase<List<LookUpItem>, CategoriesRequestParams> {
  final ActivitesRepository repository;

  GetCategoriesUc({required this.repository});

  @override
  Future<Either<Failure, List<LookUpItem>>> call(
      CategoriesRequestParams params) async {
    return await repository.getcategories(params);
  }
}
