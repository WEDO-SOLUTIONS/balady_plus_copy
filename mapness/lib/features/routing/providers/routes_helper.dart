import 'dart:async';

import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes_helper.g.dart';

@riverpod
class RoutesHelper extends _$RoutesHelper {
  @override
  void build() {
    final cameraPadding = ref.read(cameraPaddingProvider.notifier);
    ref.onDispose(() {
      detach(Future<void>.microtask(cameraPadding.resetPadding), tag: 'routesHelper.microtask');
    });
  }
}
