import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

const _kChatPlaceMarkerId = 'chat-place-marker';

/// "Open on map" for a place-card message (R-117). Same context-independent
/// routing as `open_meetup_on_map.dart` (read its comment for why the nested
/// `MapRoute` router is resolved from the root, not from `context`), but with
/// a plain pin — no meetup info sheet, whose "remove pin" action would try to
/// dismiss a meetup that doesn't exist for a chat message.
void openChatPlaceOnMap(WidgetRef ref, ChatPlace place, {String? title}) {
  final mapRouter = ref.read(appRouterProvider).innerRouterOf<StackRouter>(MapRoute.name);
  mapRouter?.popUntil((route) => route.settings.name == BottomMenuRoute.name);
  mapRouter?.innerRouterOf<TabsRouter>(BottomMenuRoute.name)?.setActiveIndex(0);
  final cameraPosition = ref.read(cameraPositionProvider);
  ref
      .read(cameraPositionProvider.notifier)
      .animateTo(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: place.latitude, longitude: place.longitude),
          zoom: cameraPosition?.zoom ?? 17,
          tilt: cameraPosition?.tilt ?? 0,
          bearing: cameraPosition?.bearing ?? 0,
        ),
      );
  ref
      .read(selectedMarkerProvider.notifier)
      .showMarker(
        Markers.pinMarker(
          GeoPointWithElevationMessage(latitude: place.latitude, longitude: place.longitude, elevation: 1),
          id: _kChatPlaceMarkerId,
          text: place.label ?? title,
        ),
      );
}
