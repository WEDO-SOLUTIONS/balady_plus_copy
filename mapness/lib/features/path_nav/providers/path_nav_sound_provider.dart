import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_sound_provider.g.dart';

@riverpod
class _PathNavSoundProvider extends _$PathNavSoundProvider {
  Future<void> toggle() async {
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.toggleSound();
    state = !state;
  }

  @override
  bool build() {
    ref.watch(dgisControllerProvider);
    return true;
  }
}

final pathNavSoundProviderProvider = _pathNavSoundProviderProvider;
