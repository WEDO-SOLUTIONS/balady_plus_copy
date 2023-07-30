import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchRepository, SearchParams, SearchResponse;
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetSearchData
    extends UseCase<ApigeeResponse<SearchResponse>, SearchParams> {
  final SearchRepository repository;

  GetSearchData({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<SearchResponse>>> call(
      SearchParams params) async {
    return await repository.getSearchData(params: params);
  }
}
