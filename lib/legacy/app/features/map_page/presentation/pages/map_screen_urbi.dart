import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dgis_map/library.dart';
import 'package:provider/provider.dart';

class MapScreenUrbi extends StatefulWidget {
  const MapScreenUrbi({Key? key}) : super(key: key);

  @override
  State<MapScreenUrbi> createState() => _MapScreenUrbiState();
}

class _MapScreenUrbiState extends State<MapScreenUrbi>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  int _keyIndex = 0;
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
        _keyIndex += 1;
      });
    }

    if (state == AppLifecycleState.paused) {
      MapViewModel mapViewModel =
          Provider.of<MapViewModel>(context, listen: false);

      mapViewModel.saveMapState();
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

    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return DgisMap(
      key: ValueKey(_keyIndex),
      androidUseExpensive: true,
      onMapCreated: (DgisMapController controller) async {
        await mapViewModel.initialize(controller);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
