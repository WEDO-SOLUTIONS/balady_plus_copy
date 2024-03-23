import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';

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
        // _keyIndex += 1;
      });
    }

    // if (state == AppLifecycleState.paused) {
    //   MapViewModel mapViewModel =
    //       Provider.of<MapViewModel>(context, listen: false);

    //   mapViewModel.saveMapState();
    // }
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
    ref.watch(selectedMarkerProvider);
    ref.watch(mapObjectManagerProvider(named: selectedMarkerManagerId));

    return DgisMap(
      key: ValueKey(_keyIndex),
      androidUseExpensive: true,
      onMapCreated: (controller) async {
        await dgisController.onMapCreated(controller);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
