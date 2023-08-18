import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dgis_map/library.dart';
import 'package:provider/provider.dart';

class MapScreenUrbi extends StatefulWidget {
  const MapScreenUrbi({Key? key}) : super(key: key);

  static ValueKey mapKey = const ValueKey("DgisMap");

  @override
  State<MapScreenUrbi> createState() => _MapScreenUrbiState();
}

class _MapScreenUrbiState extends State<MapScreenUrbi>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return DgisMap(
      key: MapScreenUrbi.mapKey,
      logOptions: LogOptionsMessage(
        systemLevel: LogLevelMessage.error,
        customLevel: LogLevelMessage.error,
        customSink: "BaladyDGis",
      ),
      androidUseExpensive: true,
      onMapCreated: (DgisMapController controller) async {
        await mapViewModel.initialize(controller);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
