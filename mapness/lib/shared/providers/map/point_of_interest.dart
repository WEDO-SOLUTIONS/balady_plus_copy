import 'package:dgis_map/library.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_of_interest.g.dart';

class PoiModel {
  final DirectoryObjectMessage? directoryObjectMessage;
  final List<BriefRouteInfoMessage?>? briefeRouteInfos;

  PoiModel({
    required this.directoryObjectMessage,
    this.briefeRouteInfos,
  });

  String? getBriefRouteDescription(AppLocalizations l10n) {
    final int = briefeRouteInfos?.first?.duration.toInt();
    if (int != null) {
      final duration = Duration(seconds: int);
      final inMinutes = duration.inMinutes;
      if(inMinutes<60){
      return '$inMinutes ${l10n.min}';
      }else{
        var inHours = duration.inHours;
      return '$inHours ${l10n.hrs}';
      }
    }
    return null;
  }
}

@riverpod
Future<DirectoryObjectMessage?> pointOfInterest(
  PointOfInterestRef ref,
  DgisObjectIdMessage objectId,
) async {
  final dgisController = ref.watch(dgisControllerProvider);
  final cameraController = ref.watch(cameraPositionProvider.notifier);
  final highlightController = ref.watch(highlightProvider.notifier);
  final result = await dgisController?.searchByObjectId(objectId);

  print(
    'coordinates: ${result?.markerPosition?.latitude} ${result?.markerPosition?.longitude}',
  );

  await highlightController.addHighlight(objectId);
  ref.onDispose(() {
    highlightController.removeAll();
  });
  if (result == null || result.markerPosition == null) return null;

  await cameraController.animateTo(
    CameraPositionMessage(
      point: GeoPointMessage(
        latitude: result.markerPosition!.latitude,
        longitude: result.markerPosition!.longitude,
      ),
      zoom: 17,
      tilt: 45,
      bearing: 0,
    ),
  );
  final markerId = 'pointOfInterest-$objectId';
  await dgisController?.addMarker(
    Marker(
      id: markerId,
      options: MarkerOptionsMessage(
        position: result.markerPosition!,
        icon: MarkerIconMessage(
          path: "packages/mapness/assets/icons/svg/ic_pin.svg",
          width: 24,
        ),
        anchor: MarkerAnchorMessage(x: 0.5, y: 1),
        animatedAppearance: true,
      ),
    ),
  );
  ref.onDispose(() {
    dgisController?.removeMarker(markerId);
  });

  return result;
}
