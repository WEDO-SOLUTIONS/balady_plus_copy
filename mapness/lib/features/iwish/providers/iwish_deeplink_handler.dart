import 'package:collection/collection.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_deeplink_handler.g.dart';

enum LangingFocusMaker { iwish, mosques }

@riverpod
class IwishDeeplinkHandler extends _$IwishDeeplinkHandler {
  static const focusMarkerKey = 'focus-maker';

  @override
  LangingFocusMaker? build() => null;

  void handleDeeplink(Uri uri) {
    state = LangingFocusMaker.values.firstWhereOrNull(
      (element) => element.name == uri.queryParameters[focusMarkerKey],
    );
    if (state != null) {
      if (state == LangingFocusMaker.iwish) {
        _handleIwish();
      } else if (state == LangingFocusMaker.mosques) {
        _handleMosques();
      }
    }
  }

  void _handleIwish() {
    if (ref.read(layersControlsProvider).selectedType != LayerType.joy) {
      ref.read(layersControlsProvider.notifier).handleTap(LayerType.joy);
    }
  }

  void _handleMosques() {
    // TODO: implement _handleMosques
  }
}
