import 'package:dgis_map_platform_interface/library.dart';
import 'package:flutter/widgets.dart';

import 'dgis_map_controller.dart';

///  Setting [androidUseExpensive] to true eradicates spaming "SurfaceView"
///  on some Android devices. It may cause performance loss on devices with API < 10
class DgisMap extends StatelessWidget {
  const DgisMap({
    required this.onMapCreated,
    this.androidUseExpensive = false,
    super.key,
  });

  final Function(DgisMapController controller) onMapCreated;
  final bool androidUseExpensive;

  @override
  Widget build(BuildContext context) {
    return DgisMapPlugin.instance.buildView(
      androidUseExpensive: androidUseExpensive,
      onPlatformViewCreated: (viewId) => onMapCreated(DgisMapController(viewId)),
    );
  }
}
