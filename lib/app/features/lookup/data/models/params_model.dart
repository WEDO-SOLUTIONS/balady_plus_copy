import 'package:equatable/equatable.dart' show Equatable;

import '../../../../core/utils/utils_exports.dart' show LookupKey;

class LookupParamsModel extends Equatable {
  final LookupKey key;
  final String? filterValue;
  final Map<String, dynamic>? queryParams;

  const LookupParamsModel({
    required this.key,
    this.filterValue,
    this.queryParams,
  });

  @override
  List<Object?> get props => [key, filterValue, queryParams];
}
