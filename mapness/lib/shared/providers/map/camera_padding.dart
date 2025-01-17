import 'package:dgis_map/library.dart';
import 'package:mapness/shared/extensions/media_query_data_ext.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_padding.g.dart';

@Riverpod(keepAlive: true)
class CameraPadding extends _$CameraPadding {
  @override
  CameraSetPaddingMessage? build() => null;

  Future<void> resetPadding({CameraSetPaddingMessage? defaultPadding}) async {
    if (defaultPadding != null) {
      await setPadding(defaultPadding);
    } else {
      final mediaQuery = ref.read(mediaQueryInfoProvider);

      final initPadding = mediaQuery?.initialMapPadding ?? 0.0;

      final padding = CameraSetPaddingMessage(
        leftPadding: mediaQuery?.padding.left.toInt() ?? 0,
        rightPadding: mediaQuery?.padding.right.toInt() ?? 0,
        topPadding: mediaQuery?.padding.top.toInt() ?? 0,
        bottomPadding: initPadding.toInt(),
      );

      await setPadding(padding);
    }
  }

  Future<void> setPadding(CameraSetPaddingMessage padding) async {
    final cameraProvider = ref.read(cameraPositionProvider.notifier);

    state = padding;

    await cameraProvider.setPadding(padding);
  }

  Future<void> setPaddingInBottom(double paddingBottom) async {
    final mediaQuery = ref.read(mediaQueryInfoProvider);

    final initPadding = (paddingBottom + (mediaQuery?.padding.bottom ?? 0)) * (mediaQuery?.devicePixelRatio ?? 1);

    final padding = CameraSetPaddingMessage(
      leftPadding: mediaQuery?.padding.left.toInt() ?? 0,
      rightPadding: mediaQuery?.padding.right.toInt() ?? 0,
      topPadding: mediaQuery?.padding.top.toInt() ?? 0,
      bottomPadding: initPadding.toInt(),
    );

    await setPadding(padding);
  }
}
