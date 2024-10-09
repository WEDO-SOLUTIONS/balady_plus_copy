import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/others/transparent_pointer.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';

@RoutePage()
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
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
  Widget build(BuildContext context) {
    super.build(context);

    final dgisController = ref.watch(dgisControllerProvider.notifier);
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
          },
        ),
        const TransparentPointer(child: AutoRouter()),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
