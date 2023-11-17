import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/map/providers/dgis_controller.dart';
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
    ref.watch(dgisControllerProvider)?.setHighlighted(state);
  }

  Future<void> removeHighlight(DgisObjectIdMessage objectId) async {
    state = state.whereNot((element) => element == objectId).toList();
    ref.watch(dgisControllerProvider)?.setHighlighted(state);
  }
}
