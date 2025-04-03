import 'package:dgis_map/library.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';

extension IwishMarkerMapper on IwishMarker {
  Marker toMarker({
    required bool isSelected,
    required Function(IwishMarker) onMarkerTap,
  }) {
    // TODO(demezy): place here logic when backend will provide state
    // and replace current `icon` with `MarkerIconMessage` with proper path
    // ignore: unused_local_variable
    final path = switch ((isSelected, state)) {
      (true, _) => LayersSvgPathsDeprecated.joyParkSelected,
      (_, IwishState.completed) => LayersSvgPathsDeprecated.joyParkCompleted,
      (_, _) => LayersSvgPathsDeprecated.joyParkPlanned,
    };
    return Marker(
      id: '$iwishMarkerPrefix$id',
      options: MarkerOptionsMessage(
        position: GeoPointWithElevationMessage(
          latitude: location.latitude,
          longitude: location.longitude,
          elevation: 0,
        ),
        icon: path.markerIcon(),
      ),
      onTap: () => onMarkerTap(this),
    );
  }
}
