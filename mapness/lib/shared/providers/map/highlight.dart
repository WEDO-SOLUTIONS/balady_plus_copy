import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'highlight.g.dart';

@riverpod
class Highlight extends _$Highlight {
  @override
  List<DgisObjectIdMessage> build() {
    return [];
  }

  Future<void> addHighlight(DgisObjectIdMessage objectId) async {
    state = [...state, objectId];
    ref.read(dgisControllerProvider).value?.setHighlighted(state);
  }

  Future<void> removeHighlight(DgisObjectIdMessage objectId) async {
    state = state.whereNot((element) => element == objectId).toList();
    ref.read(dgisControllerProvider).value?.setHighlighted(state);
  }

  Future<void> removeAll() async {
    ref.read(dgisControllerProvider).value?.setHighlighted([]);
    state.clear();
  }
}
