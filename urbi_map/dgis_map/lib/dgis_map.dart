import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'dgis_map_controller.dart';

const String _viewType = 'com.dgis.map_view';

///  Setting [androidUseExpensive] to true eradicates spaming "SurfaceView"
///  on some Android devices. It may cause performance loss on devices with API < 10
class DgisMap extends StatelessWidget {
  DgisMap({
    required this.onMapCreated,
    this.androidUseExpensive = false,
    super.key,
  });

  final Function(DgisMapController controller) onMapCreated;
  final bool androidUseExpensive;
  late final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
    Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()),
  };

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.android
        ? AndroidView(
            key: key,
            viewType: _viewType,
            onPlatformViewCreated: (viewId) {
              final controller = DgisMapController(viewId);
              onMapCreated(controller);
            },
            gestureRecognizers: _gestureRecognizers,
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            layoutDirection: TextDirection.ltr,
          )
        : UiKitView(
            key: key,
            viewType: _viewType,
            layoutDirection: TextDirection.ltr,
            gestureRecognizers: _gestureRecognizers,
            onPlatformViewCreated: (viewId) {
              final controller = DgisMapController(viewId);
              onMapCreated(controller);
            },
          );
  }
}
