import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchParams, SearchResponse;
import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class SearchRepository {
  Future<Either<Failure, ApigeeResponse<SearchResponse>>> getSearchData(
      {required SearchParams params});
}
