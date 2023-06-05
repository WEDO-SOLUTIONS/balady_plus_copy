import '../../../../core/utils/utils_exports.dart' show LookupKey;
import '../../lookup_exports.dart' show LookupParamsModel;

class LookupParams extends LookupParamsModel {
  const LookupParams({
    super.key = LookupKey.empty,
    super.filterValue,
    super.queryParams,
  });

  LookupParams copyWith({
    LookupKey? key,
    String? filterValue,
    Map<String, dynamic>? queryParams,
  }) {
    return LookupParams(
      key: key ?? this.key,
      filterValue: filterValue ?? this.filterValue,
      queryParams: queryParams ?? this.queryParams,
    );
  }

  @override
  String toString() =>
      'LookupParams(key: $key, filterValue: $filterValue, queryParams: $queryParams)';
}
