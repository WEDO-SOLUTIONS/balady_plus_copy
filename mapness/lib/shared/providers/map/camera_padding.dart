import 'dart:io';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_padding.g.dart';

@Riverpod(keepAlive: true)
class CameraPadding extends _$CameraPadding {
  @override
  CameraSetPaddingMessage? build() => null;

  Future<void> resetPadding({CameraSetPaddingMessage? defaultPadding, bool applyForIos = false}) async {
    if (defaultPadding != null) {
      await setPadding(defaultPadding, applyForIos: applyForIos);
    } else {
      final mediaQuery = ref.read(mediaQueryInfoProvider);

      final pixelSize = mediaQuery?.devicePixelRatio ?? 1.0;
      final navbarSize = 48 + (mediaQuery?.viewPadding.bottom ?? 0.0);
      final int qfilterPadding = (48 * pixelSize).floor();
      final deviceHeight = mediaQuery?.size.height ?? 0.0;

      // Update when ui-kit bottom sheet is implemented
      final initBottomSize = Platform.isIOS ? .3 : .38;

      // calculate intitial padding for camera
      final initPadding = (initBottomSize * deviceHeight * pixelSize) + (navbarSize * pixelSize) + qfilterPadding;
      final padding = CameraSetPaddingMessage(
        leftPadding: mediaQuery?.padding.left.toInt() ?? 0,
        rightPadding: mediaQuery?.padding.right.toInt() ?? 0,
        topPadding: mediaQuery?.padding.top.toInt() ?? 0,
        bottomPadding: initPadding.toInt(),
      );

      await setPadding(padding, applyForIos: applyForIos);
    }
  }

  Future<void> setPadding(CameraSetPaddingMessage padding, {bool applyForIos = false}) async {
    final cameraProvider = ref.watch(cameraPositionProvider.notifier);
    if (applyForIos == false && Platform.isIOS) {
      await cameraProvider.setPadding(
        CameraSetPaddingMessage(
          bottomPadding: 0,
          topPadding: 0,
          leftPadding: 0,
          rightPadding: 0,
        ),
      );
      return;
    }

    state = padding;

    await cameraProvider.setPadding(padding);
  }
}
