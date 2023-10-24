import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggests.g.dart';

@riverpod
class Suggests extends _$Suggests {
  @override
  List<SuggestMessage> build() => [];

  Future<void> fetch(String query) async {
    final dgisController = ref.watch(dgisControllerProvider);

    final result = await dgisController?.fetchSuggest(query);
    state = result?.suggests.whereType<SuggestMessage>().toList() ?? [];
  }
}
