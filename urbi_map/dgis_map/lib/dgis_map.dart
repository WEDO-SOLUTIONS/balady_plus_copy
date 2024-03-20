import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'dgis_map_controller.dart';

const String _viewType = 'com.dgis.map_view';

///  Setting [androidUseExpensive] to true eradicates spaming "SurfaceView"
///  on some Android devices. It may cause performance loss on devices with API < 10
class DgisMap extends StatefulWidget {
  DgisMap({
    required this.onMapCreated,
    required this.routeObserver,
    this.androidUseExpensive = false,
    required Key key,
  }) : super(key: key);

  final RouteObserver<ModalRoute<void>> routeObserver;
  final Function(DgisMapController controller) onMapCreated;
  final bool androidUseExpensive;

  @override
  State<DgisMap> createState() => _DgisMapState();
}

class _DgisMapState extends State<DgisMap> with RouteAware {
  final ValueNotifier<DgisMapController?> _dgisController = ValueNotifier(null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print("Map ${widget.key} didPush");
  }

  @override
  void didPopNext() {
    print("Map ${widget.key} didPopNext");
  }

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.android
        ? AndroidView(
            key: widget.key,
            viewType: _viewType,
            onPlatformViewCreated: (viewId) {
              final controller = DgisMapController(viewId);
              _dgisController.value = controller;
              widget.onMapCreated(controller);
            },
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            layoutDirection: TextDirection.ltr,
          )
        : UiKitView(
            key: widget.key,
            viewType: _viewType,
            layoutDirection: TextDirection.ltr,
            onPlatformViewCreated: (viewId) {
              final controller = DgisMapController(viewId);
              _dgisController.value = controller;
              widget.onMapCreated(controller);
            },
          );
  }
}
