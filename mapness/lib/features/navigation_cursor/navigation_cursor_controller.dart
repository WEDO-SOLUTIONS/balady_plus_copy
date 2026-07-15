import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_provider.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_service.dart';
import 'package:mapness/features/navigation_cursor/cursor_downloader.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/shared/constants/constants.dart';
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
///   * classic → [DynamicStyleController.resetToBundled].
///   * non-classic + already downloaded → [_apply].
///   * non-classic + missing → [CursorDownloader.download] → [_apply].
/// Every path persists activeId, so a kill/restart lands on the same cursor.
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
      if (cursor == NavigationCursor.classic) {
        await ref.read(dynamicStyleControllerProvider.notifier).resetToBundled();
      } else {
        final downloader = ref.read(cursorDownloaderProvider);
        final file = await downloader.download(cursor);
        final bytes = await file.readAsBytes();
        await ref.read(dynamicStyleControllerProvider.notifier).applyOverrides([
          for (final path in kNavigationCursorCarModelPaths) StyleEntryOverride(archivePath: path, bytes: bytes),
        ]);
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

  void clearError() {
    if (state.lastError == null) {
      return;
    }
    state = state.copyWith(clearError: true);
  }
}
