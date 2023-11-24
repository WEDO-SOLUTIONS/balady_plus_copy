import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggest.g.dart';

@riverpod
class SuggestQuery extends _$SuggestQuery {
  @override
  String build() => "";

  void update(String value) {
    state = value;
  }
}

@riverpod
class SuggestResults extends _$SuggestResults {
  @override
  Future<List<SuggestMessage>> build() async {
    final query = ref.watch(suggestQueryProvider);

    if (query.isNotEmpty) {
      return await _fetch(query);
    }

    return [];
  }

  Future<List<SuggestMessage>> _fetch(String query) async {
    final dgisController = ref.watch(dgisControllerProvider);

    final result = await dgisController?.fetchSuggest(query);
    return result?.suggests.whereType<SuggestMessage>().toList() ?? [];
  }
}
