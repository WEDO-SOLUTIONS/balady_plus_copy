import 'dart:async';

import 'package:archive/archive.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/navigation_cursor/cursor_downloader.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_cursor_controller.g.dart';

const _logTag = '[navigation_cursor]';
const _downloadedIdsPrefsKey = 'downloadedNavigationCursors';

/// Snapshot of every UI-relevant fact about the cursor picker.
@immutable
class NavigationCursorState {
  const NavigationCursorState({
    required this.active,
    required this.downloadedIds,
    this.inProgress,
    this.lastError,
  });

  /// Currently-applied cursor. Always includes [NavigationCursor.classic]
  /// as the safe default even if SharedPreferences is empty.
  final NavigationCursor active;

  /// Ids of cursors whose GLB is present on disk (plus `classic`, which is
  /// bundled). Ordering is not meaningful — the UI sorts by enum.
  final Set<String> downloadedIds;

  /// The cursor currently being downloaded/applied, or null if idle. Only
  /// one download at a time — subsequent taps queue up.
  final NavigationCursor? inProgress;

  /// The last error surfaced by [NavigationCursorController.select]. UI
  /// clears it via [NavigationCursorController.clearError] when dismissed.
  final Object? lastError;

  bool isDownloaded(NavigationCursor cursor) => downloadedIds.contains(cursor.id);

  NavigationCursorState copyWith({
    NavigationCursor? active,
    Set<String>? downloadedIds,
    NavigationCursor? inProgress,
    bool clearInProgress = false,
    Object? lastError,
    bool clearError = false,
  }) => NavigationCursorState(
    active: active ?? this.active,
    downloadedIds: downloadedIds ?? this.downloadedIds,
    inProgress: clearInProgress ? null : (inProgress ?? this.inProgress),
    lastError: clearError ? null : (lastError ?? this.lastError),
  );
}

/// Orchestrates cursor selection.
///
/// build() returns a synchronous initial snapshot (classic + persisted
/// active if it looks plausible) so the picker never opens on a spinner.
/// A background disk scan then reconciles the `downloadedIds` set — as
/// soon as it lands, previously-downloaded cursors reappear in the "Your
/// cursors" section. Disk wins: if the user cleared app data, the
/// persisted list is trimmed and the active cursor rolls back to classic.
///
/// select(cursor) is the single UI entry-point:
///   * classic → bundled day/night car GLB from the style archive.
///   * non-classic + already downloaded → GLB from disk.
///   * non-classic + missing → [CursorDownloader.download] → GLB from disk.
/// The GLB bytes go straight to the live map via
/// [DgisMapController.setNavigationCursorModel] (SDK
/// `MyLocationMapObject.setModelData`) — no style repack, no MapView
/// recreate, so the route, maneuvers and camera are never disturbed
/// (BALADY-3772). Every path persists activeId; [applyActive] re-applies
/// it whenever a map (re)initialises and when the day/night appearance
/// flips (the bundled classic car has distinct day/night meshes).
@Riverpod(keepAlive: true)
class NavigationCursorController extends _$NavigationCursorController {
  @override
  NavigationCursorState build() {
    final prefs = ref.read(sharedPrefsProvider);
    final storedActive = NavigationCursor.fromId(
      prefs.getString(MapnessConstants.activeNavigationCursorPrefsKey),
    );
    // Optimistic initial set — classic is always present; the persisted
    // active is assumed downloaded until the disk scan (below) confirms
    // otherwise. This keeps the picker from flashing "Available" on the
    // active cursor.
    final persistedList = prefs.getStringList(_downloadedIdsPrefsKey) ?? const <String>[];
    final initialDownloaded = <String>{NavigationCursor.classic.id}
      ..addAll(persistedList)
      ..add(storedActive.id);
    // Kick off the disk reconcile off the build stack — reading files
    // must not block first paint.
    Future.microtask(_reconcileWithDisk);
    return NavigationCursorState(active: storedActive, downloadedIds: initialDownloaded);
  }

  Future<void> _reconcileWithDisk() async {
    try {
      final onDisk = await ref.read(cursorDownloaderProvider).downloadedIds();
      final downloaded = <String>{NavigationCursor.classic.id, ...onDisk};
      final current = state;
      var active = current.active;
      if (!downloaded.contains(active.id)) {
        logger.log('$_logTag reconcile: ${active.id} no longer on disk → falling back to classic');
        active = NavigationCursor.classic;
      }
      state = current.copyWith(active: active, downloadedIds: downloaded);
      final prefs = ref.read(sharedPrefsProvider);
      if (active != current.active) {
        await prefs.setString(MapnessConstants.activeNavigationCursorPrefsKey, active.id);
      }
      await prefs.setStringList(
        _downloadedIdsPrefsKey,
        downloaded.where((id) => id != NavigationCursor.classic.id).toList(),
      );
    } catch (e, st) {
      logger.log('$_logTag reconcile: FAILED: $e\n$st', logLevel: MapnessLogLevel.warning);
    }
  }

  /// Apply [cursor] as the active navigation car model. Downloads the GLB
  /// first if it's not on disk yet. Persists activeId on success.
  Future<void> select(NavigationCursor cursor) async {
    if (cursor == state.active && state.inProgress == null) {
      return;
    }
    final before = state;
    state = before.copyWith(inProgress: cursor, clearError: true);
    final sw = Stopwatch()..start();
    logger.log('$_logTag select: ${before.active.id} → ${cursor.id}');
    try {
      if (cursor != NavigationCursor.classic) {
        await ref.read(cursorDownloaderProvider).download(cursor);
      }
      final controller = activeDgisController;
      if (controller != null) {
        await controller.setNavigationCursorModel(await _modelBytes(cursor));
      } else {
        // No live map right now (e.g. picker opened before the map mounted):
        // the choice is persisted below and [applyActive] pushes it as soon
        // as a map initialises.
        logger.log('$_logTag select: no active map, ${cursor.id} will apply on next map init');
      }
      final newDownloaded = <String>{...state.downloadedIds, cursor.id};
      state = state.copyWith(active: cursor, downloadedIds: newDownloaded, clearInProgress: true);
      final prefs = ref.read(sharedPrefsProvider);
      await prefs.setString(MapnessConstants.activeNavigationCursorPrefsKey, cursor.id);
      await prefs.setStringList(
        _downloadedIdsPrefsKey,
        newDownloaded.where((id) => id != NavigationCursor.classic.id).toList(),
      );
      sw.stop();
      logger.log('$_logTag select: applied ${cursor.id} in ${sw.elapsedMilliseconds}ms');
    } catch (e, st) {
      sw.stop();
      logger.log(
        '$_logTag select: FAILED ${cursor.id} after ${sw.elapsedMilliseconds}ms: $e\n$st',
        logLevel: MapnessLogLevel.error,
      );
      state = state.copyWith(clearInProgress: true, lastError: e);
    }
  }

  /// Push the persisted active cursor onto [controller]. Called by
  /// [DgisController] once a map has initialised and whenever the day/night
  /// appearance changes. Failures are logged, never thrown — a missing
  /// model must not break map setup.
  Future<void> applyActive(DgisMapController controller) async {
    final cursor = state.active;
    try {
      await controller.setNavigationCursorModel(await _modelBytes(cursor));
      logger.log('$_logTag applyActive: ${cursor.id}');
    } catch (e, st) {
      logger.log('$_logTag applyActive: FAILED for ${cursor.id}: $e\n$st', logLevel: MapnessLogLevel.warning);
    }
  }

  /// GLB bytes for [cursor]. Downloaded cursors ship a single mesh; the
  /// bundled classic car has separate day/night meshes inside the style
  /// archive, picked by the current appearance.
  Future<Uint8List> _modelBytes(NavigationCursor cursor) async {
    if (cursor != NavigationCursor.classic) {
      return (await ref.read(cursorDownloaderProvider).localFile(cursor)).readAsBytes();
    }
    final isDark = (await ref.read(darkModeProvider.future)).isDark;
    final entryName = isDark ? kNavigationCursorCarModelPaths[1] : kNavigationCursorCarModelPaths[0];
    return _bundledStyleEntry(entryName);
  }

  static final _bundledEntryCache = <String, Uint8List>{};

  /// Read one entry out of the bundled `.2gis` (a zip). The archive is
  /// ~10 MB and read only once per entry; both classic meshes get cached.
  Future<Uint8List> _bundledStyleEntry(String name) async {
    final cached = _bundledEntryCache[name];
    if (cached != null) {
      return cached;
    }
    final data = await rootBundle.load(MapnessConstants.mapStylesPath);
    final archive = ZipDecoder().decodeBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    final entry = archive.files.firstWhere(
      (f) => f.name == name,
      orElse: () => throw StateError('bundled style has no $name'),
    );
    final bytes = Uint8List.fromList(entry.readBytes() ?? const <int>[]);
    _bundledEntryCache[name] = bytes;
    return bytes;
  }

  void clearError() {
    if (state.lastError == null) {
      return;
    }
    state = state.copyWith(clearError: true);
  }

  /// TEMP (debug): drop [cursor]'s cached GLB and its entry from
  /// downloadedIds so the next tap re-downloads from CDN. If it was the
  /// active cursor, roll back to [NavigationCursor.classic] and reload the
  /// bundled style. Returns true if something was actually deleted.
  Future<bool> deleteLocal(NavigationCursor cursor) async {
    if (!cursor.requiresDownload) {
      return false;
    }
    final deleted = await ref.read(cursorDownloaderProvider).deleteLocal(cursor);
    if (!deleted && !state.downloadedIds.contains(cursor.id)) {
      return false;
    }
    final previousActive = state.active;
    final newDownloaded = <String>{...state.downloadedIds}..remove(cursor.id);
    var newActive = previousActive;
    if (previousActive == cursor) {
      newActive = NavigationCursor.classic;
      try {
        final controller = activeDgisController;
        if (controller != null) {
          await controller.setNavigationCursorModel(await _modelBytes(NavigationCursor.classic));
        }
      } catch (e, st) {
        logger.log(
          '$_logTag deleteLocal: reverting to classic FAILED for ${cursor.id}: $e\n$st',
          logLevel: MapnessLogLevel.warning,
        );
      }
    }
    state = state.copyWith(active: newActive, downloadedIds: newDownloaded);
    final prefs = ref.read(sharedPrefsProvider);
    if (newActive != previousActive) {
      await prefs.setString(MapnessConstants.activeNavigationCursorPrefsKey, newActive.id);
    }
    await prefs.setStringList(
      _downloadedIdsPrefsKey,
      newDownloaded.where((id) => id != NavigationCursor.classic.id).toList(),
    );
    logger.log('$_logTag deleteLocal: ${cursor.id} dropped (activeNow=${newActive.id})');
    return deleted;
  }
}
