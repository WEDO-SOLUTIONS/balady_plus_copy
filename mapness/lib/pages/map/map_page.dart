import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';

@RoutePage()
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final int _keyIndex = 0;
  bool _needRefresh = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_needRefresh && state == AppLifecycleState.resumed) {
      setState(() {
        _needRefresh = false;
      });
    }
  }

  @override
  void didHaveMemoryPressure() {
    setState(() {
      _needRefresh = true;
    });
    super.didHaveMemoryPressure();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final dgisController = ref.watch(dgisControllerProvider.notifier);

    ref.watch(selectedMarkerProvider);
    final settings = MapObjectManagerSettings.selectedMarker();
    ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        DgisMap(
          key: ValueKey(_keyIndex),
          androidUseExpensive: true,
          onMapCreated: (controller) async {
            await dgisController.onMapCreated(controller);
            Future.delayed(const Duration(seconds: 3), () {
              ref.read(layersControlsProvider.notifier).showActiveLayerOnMap();
            });
          },
        ),
        const AutoRouter(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
