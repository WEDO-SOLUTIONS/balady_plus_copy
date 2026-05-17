import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes_helper.g.dart';

@riverpod
class RoutesHelper extends _$RoutesHelper {
  @override
  void build() {
    final padding = ref.read(cameraPaddingProvider.notifier);
    // resetPadding uses ref.read() internally; defer past the dispose cycle
    // to avoid Riverpod's "Cannot use Ref inside life-cycles" assertion.
    ref.onDispose(() => Future.microtask(padding.resetPadding));
  }
}
