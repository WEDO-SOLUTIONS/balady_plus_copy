import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'highlight.g.dart';

@Riverpod(keepAlive: true)
class Highlight extends _$Highlight {
  @override
  List<DgisObjectIdMessage> build() => [];

  Future<void> addHighlight(DgisObjectIdMessage objectId) async {
    if (!_containsObject(objectId)) {
      state = [...state, objectId];
      await ref.read(dgisControllerProvider).value?.setHighlighted(state);
    }
  }

  // BALADY-21: road-event markers share entranceId == 0, so de-dup on the full
  // (objectId, entranceId) pair to allow switching between adjacent closures.
  bool _containsObject(DgisObjectIdMessage id) =>
      state.any((element) => element.objectId == id.objectId && element.entranceId == id.entranceId);

  Future<void> removeHighlight(DgisObjectIdMessage objectId) async {
    state = state.whereNot((element) => element == objectId).toList();
    await ref.read(dgisControllerProvider).value?.setHighlighted(state);
  }

  Future<void> removeAll() async {
    await ref.read(dgisControllerProvider).value?.setHighlighted([]);
    state.clear();
  }
}
