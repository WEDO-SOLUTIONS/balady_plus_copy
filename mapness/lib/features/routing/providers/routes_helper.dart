import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes_helper.g.dart';

@riverpod
class RoutesHelper extends _$RoutesHelper {
  @override
  void build() {
    ref.onDispose(() {
      ref.read(cameraPaddingProvider.notifier).resetPadding();
    });
  }
}
