import 'package:dgis_map/library.dart';
import 'package:image/image.dart' as img;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_layer_visible.dart';
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_markers.g.dart';

const int _kMarkerSizePx = 48;
const double _kMarkerSize = 48;

// keepAlive: must keep drawing/clearing markers regardless of which screen
// is focused — same rationale as `friends_on_map_position_reporter.dart`.
// Watched from `pages/map/map_page.dart` (the always-mounted root route) so
// it's actually alive to do that.
@Riverpod(keepAlive: true)
class FriendMarkers extends _$FriendMarkers {
  @override
  Future<void> build() async {
    try {
      final visible = ref.watch(friendsOnMapLayerVisibleProvider);
      final settings = MapObjectManagerSettings.friends();
      // Must be `ref.watch`, not `ref.read` — `mapObjectManagerProvider` is
      // auto-dispose, and `read` doesn't create a keep-alive listener edge.
      // Reading it here let it get disposed mid-flight, causing every build
      // to throw "Cannot use the Ref of ... after it has been disposed."
      // `watch` matches the working pattern in `pages/map/map_page.dart`'s
      // `selectedMarker` layer.
      final manager = ref.watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier);
      // Wait for the manager — and, transitively, dgisControllerProvider —
      // to be fully ready before mutating it. Without this,
      // object_manager.dart's `ref.read(dgisControllerProvider).value?.foo(
      // ...)` calls silently no-op (standard Dart null-aware short-circuit:
      // the receiver is checked before any argument, including `await
      // future`, is even evaluated) whenever the native map hasn't fired
      // onMapCreated yet — guaranteed true the very first time this
      // provider builds, since that happens during MapPage's first build,
      // before DgisMap can have created its controller.
      await ref.watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).future);

      if (!visible) {
        await manager.removeAllMarkers();
        return;
      }

      final friends = await ref.watch(friendsListProvider.future);
      final visibleFriends = friends.where((f) => f.latitude != null && f.longitude != null).toList();

      final markers = await Future.wait(visibleFriends.map(_buildMarker));

      await manager.removeAllMarkers();
      await manager.addMarkers(markers);
    } catch (ex, stackTrace) {
      // No ProviderObserver exists in this app, and this provider is only
      // ever bare-`ref.watch`'d (never `.when()`'d) — without this, a
      // failure here becomes a silent, unread AsyncError indistinguishable
      // from "markers just aren't rendering." Rethrow so the AsyncError
      // state is unchanged; this only adds visibility.
      logger.log('Error building friend markers: $ex\n$stackTrace');
      rethrow;
    }
  }

  // R-52 (S-15) will wire a real onTap here later — for this slice, a
  // marker is drawn but tapping it does nothing.
  Future<Marker> _buildMarker(Friend friend) async {
    final position = GeoPointWithElevationMessage(
      latitude: friend.latitude!,
      longitude: friend.longitude!,
      elevation: 0,
    );
    final pictureUrl = friend.profilePictureUrl;

    final icon = pictureUrl == null
        ? SvgMarkerIcon(svgPath: Assets.icons.svg.icProfile2.keyName, width: _kMarkerSize)
        : PngBytesMarkerIcon(
            pngData: img.encodePng(await EtaUtils.processImage(pictureUrl, _kMarkerSizePx)),
            width: _kMarkerSize,
          );

    return Marker(
      id: 'friend_marker_${friend.id}',
      options: MarkerOptionsMessage(position: position, icon: icon, animatedAppearance: true, zIndex: 50),
    );
  }
}
