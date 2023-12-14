import 'package:dgis_map/library.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_by_rubrics.g.dart';

@riverpod
class SearchByRubricsQuery extends _$SearchByRubricsQuery {
  @override
  (QuickFilter, int)? build() {
    return null;
  }

  void update((QuickFilter filter, int index)? newState) => state = newState;
}

@riverpod
class SearchByRubrics extends _$SearchByRubrics {
  @override
  SearchResultMessage? build() {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) return null;

    final dgisController = ref.watch(dgisControllerProvider).value;

    if (filter.$1.rubrics.isEmpty && filter.$1.query != null) {
      dgisController
          ?.search(
            filter.$1.query!,
            sortingType: SortingTypeMessage.byRelevance,
          )
          .then(
            (value) => state = value,
          );
    } else {
      dgisController
          ?.searchByRubrics(
            filter.$1.rubrics,
            sortingType: SortingTypeMessage.byRelevance,
          )
          .then(
            (value) => state = value,
          );
    }

    return null;
  }
}
