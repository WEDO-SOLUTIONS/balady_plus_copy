import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart' as data;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_filters.g.dart';

@riverpod
Future<List<QuickFilter>> quickFilters(QuickFiltersRef ref) async {
// TODO: load from server
  return data.quickFilters;
}
