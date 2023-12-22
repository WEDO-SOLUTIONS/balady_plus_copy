import 'package:dgis_map/library.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';

extension IwishMarkerMapper on IwishMarker {
  Marker toMarker(
    final bool isSelected,
    final Function(IwishMarker) onMarkerTap,
  ) {
    return Marker(
      id: "$iwishMarkerPrefix$id",
      options: MarkerOptionsMessage(
        position: GeoPointWithElevationMessage(
          latitude: location.latitude,
          longitude: location.longitude,
          elevation: 0,
        ),
        icon: MarkerIconMessage(
          // TODO(demezy): place here logic when backend will provide state
          path: switch ((isSelected, state)) {
            (true, _) =>
              "packages/mapness/assets/icons/svg/ic_iwish_marker_selected.svg",
            (_, IwishState.completed) =>
              "packages/mapness/assets/icons/svg/ic_iwish_marker_completed.svg",
            (_, _) =>
              "packages/mapness/assets/icons/svg/ic_iwish_marker_planned.svg",
          },
          width: 30,
        ),
        // text: "JOY Parks",
        // textStyle: MarkerTextStyleMessage(
        //   color: const Color(0xFF1BA136).value,
        //   strokeColor: Colors.white.value,
        //   strokeWidth: 1,
        //   fontSize: 14,
        //   fontName: "Frutiger",
        //   textPlacement: MarkerTextPlacementMessage(
        //     placement: TextPlacementMessage.bottomCenter,
        //   ),
        // ),
      ),
      onTap: () => onMarkerTap(this),
    );
  }
}
