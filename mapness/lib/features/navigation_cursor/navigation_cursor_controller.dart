import 'package:archive/archive.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_cursor_controller.g.dart';

const _logTag = '[navigation_cursor]';

/// Pushes the bundled car cursor model onto the live map (BALADY-3772).
///
/// The GLB bytes go straight to the map via
/// [DgisMapController.setNavigationCursorModel] (SDK
/// `MyLocationMapObject.setModelData`) — no style repack, no MapView
/// recreate, so the route, maneuvers and camera are never disturbed. The
/// native side keeps the model turn-by-turn-only: outside a guidance session
/// the bytes are merely cached and the standard my-location marker stays
/// (the car must not show on Explore or in free roam); the model is applied
/// when guidance starts and reset when the session ends.
///
/// [applyActive] runs whenever a map (re)initialises and when the day/night
/// appearance flips — the bundled car has distinct day/night meshes.
@Riverpod(keepAlive: true)
class NavigationCursorController extends _$NavigationCursorController {
  @override
  void build() {}

  /// Push the car model for the current appearance onto [controller].
  /// Called by `DgisController` once a map has initialised and whenever the
  /// day/night appearance changes. Failures are logged, never thrown — a
  /// missing model must not break map setup.
  Future<void> applyActive(DgisMapController controller) async {
    try {
      final isDark = (await ref.read(darkModeProvider.future)).isDark;
      final entryName = isDark ? kNavigationCursorCarModelPaths[1] : kNavigationCursorCarModelPaths[0];
      await controller.setNavigationCursorModel(await _bundledStyleEntry(entryName));
      logger.log('$_logTag applyActive: $entryName');
    } catch (e, st) {
      logger.log('$_logTag applyActive: FAILED: $e\n$st', logLevel: MapnessLogLevel.warning);
    }
  }

  static final _bundledEntryCache = <String, Uint8List>{};

  /// Read one entry out of the bundled `.2gis` (a zip). The archive is
  /// ~10 MB, so decoding it runs on a background isolate via [compute]:
  /// doing this on the UI isolate is a multi-second stall on real devices,
  /// which surfaced as the map going blank/white for its duration
  /// (BALADY-3772). Read only once per entry; both meshes get cached.
  Future<Uint8List> _bundledStyleEntry(String name) async {
    final cached = _bundledEntryCache[name];
    if (cached != null) {
      return cached;
    }
    final data = await rootBundle.load(MapnessConstants.mapStylesPath);
    final bytes = await compute(
      _decodeBundledStyleEntry,
      (data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), name),
    );
    _bundledEntryCache[name] = bytes;
    return bytes;
  }
}

/// Isolate entry point for [NavigationCursorController._bundledStyleEntry].
/// Top-level (not a closure) so [compute] can spawn it on a background
/// isolate; `data.$1` is the raw archive bytes, `data.$2` the entry name.
Uint8List _decodeBundledStyleEntry((Uint8List, String) data) {
  final archive = ZipDecoder().decodeBytes(data.$1);
  final entry = archive.files.firstWhere(
    (f) => f.name == data.$2,
    orElse: () => throw StateError('bundled style has no ${data.$2}'),
  );
  return Uint8List.fromList(entry.readBytes() ?? const <int>[]);
}
