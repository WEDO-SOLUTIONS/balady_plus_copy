import 'package:dgis_map/library.dart';
import 'package:image/image.dart' as img;
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/friend_marker_illustration.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';
import 'package:mapness/features/friends_on_map/models/share_watch_state.dart';
import 'package:mapness/features/friends_on_map/providers/share_watcher.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/share_watch_sheet.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_watch_marker.g.dart';

// int/double split matches friend_markers.dart's own gotcha note: the same
// "48" can't be one shared constant (PngBytesMarkerIcon.width is double,
// buildFriendMarkerIcon's size is int).
const double _kMarkerSize = 48;
const int _kMarkerIconPixelSize = 144;
const String _kMarkerId = 'share_watch_marker';

/// Draws the single live-mode marker for whatever share is currently being
/// watched (`share_watcher.dart`) — a sibling to `friend_markers.dart`'s
/// manager, on its own `MapObjectManagerSettings.shareWatch()` layer so it
/// never fights `share_eta`'s own `.eta()` manager. Eta-mode watches render
/// via `ui/widgets/share_arrival_card.dart` instead — no marker needed
/// there, same reasoning `share_eta`'s own eta mode uses a card, not just a
/// bare marker.
///
/// keepAlive + watched from `pages/map/map_page.dart`'s always-mounted
/// cascade — same rationale as `friend_markers.dart`.
@Riverpod(keepAlive: true)
class ShareWatchMarker extends _$ShareWatchMarker {
  @override
  Future<void> build() async {
    try {
      final watchState = ref.watch(shareWatcherProvider);
      final settings = MapObjectManagerSettings.shareWatch();
      // Must be `ref.watch`, not `ref.read` — see friend_markers.dart's own
      // comment on this exact gotcha (mapObjectManagerProvider is
      // auto-dispose; `read` doesn't create the keep-alive listener edge).
      final manager = ref.watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier);
      await ref.watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).future);
      if (!ref.mounted) {
        return;
      }

      final showMarker =
          watchState.status == ShareWatchStatus.live && watchState.mode == ShareMode.live && watchState.hasPosition;
      if (!showMarker) {
        await manager.removeAllMarkers();
        return;
      }

      // Same themed-illustration treatment as `friend_markers.dart` (a
      // deliberate product decision made before this session, per the
      // "add themed avatar illustrations for friends" commit — friend
      // markers never carried the real profile photo even before S-19
      // existed). Seeded by `sharerAccountId` when the backend sends it
      // (only on `snapshot` frames — see `share_watch_state.dart`'s own
      // doc comment) so the SAME person gets the EXACT SAME illustration
      // here as on their own friend marker (`friend_markers.dart` seeds on
      // `friend.id`, the identical string); falls back to
      // `sharerDisplayName` (a merely-consistent-but-not-matching seed)
      // for an older/mid-rollout backend response that lacks the field,
      // then to a stable constant if even that's missing.
      final icon = PngBytesMarkerIcon(
        pngData: img.encodePng(
          await buildFriendMarkerIcon(
            watchState.sharerAccountId ?? watchState.sharerDisplayName ?? _kMarkerId,
            _kMarkerIconPixelSize,
          ),
        ),
        width: _kMarkerSize,
      );
      if (!ref.mounted) {
        return;
      }

      final marker = Marker(
        id: _kMarkerId,
        // Same "open the sheet off the root navigator's context" tap
        // pattern as `friend_markers.dart`'s own marker — reopens the
        // exact same "stop watching" sheet the deep link itself opens, so
        // the recipient doesn't need the original link again just to stop
        // watching.
        onTap: () => showShareWatchSheet(rootNavigatorKey.currentContext!),
        options: MarkerOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: watchState.lat!,
            longitude: watchState.lon!,
            elevation: 0,
          ),
          icon: icon,
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
      if (!ref.mounted) {
        return;
      }
      await manager.removeAllMarkers();
      await manager.addMarker(marker);
    } catch (ex, stackTrace) {
      // No ProviderObserver exists in this app, and this provider is only
      // ever bare-`ref.watch`'d — same reasoning as friend_markers.dart's
      // own try/catch for why this must be logged, not silently swallowed.
      logger.log('Error building share watch marker: $ex\n$stackTrace');
      rethrow;
    }
  }
}
