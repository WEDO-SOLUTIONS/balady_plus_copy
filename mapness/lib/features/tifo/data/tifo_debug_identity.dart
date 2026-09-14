import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Debug-only identity override: play as an arbitrary TIFO user instead of the
/// host SSO account.
///
/// Staging treats the bearer as an opaque user id, so switching identity is
/// literally switching the string we send — that's what makes testing several
/// players from one device possible. The chosen id and the ids used before are
/// persisted (Hive box [_boxName]) so a restart doesn't drop the tester back
/// onto their own account mid-scenario.
///
/// Never reachable in production UI: the only writer is the TIFO debug panel.
@immutable
class TifoDebugIdentity {
  const TifoDebugIdentity({this.enabled = false, this.userId = '', this.savedIds = const []});

  /// Whether requests should use [userId] instead of the host SSO session.
  final bool enabled;

  /// The id currently acted as; empty means "nothing picked yet", which falls
  /// back to the host session even while [enabled].
  final String userId;

  /// Previously used ids, most recent first.
  final List<String> savedIds;

  /// True only when a manual id should actually replace the host bearer.
  bool get isActive => enabled && userId.isNotEmpty;

  TifoDebugIdentity copyWith({bool? enabled, String? userId, List<String>? savedIds}) => TifoDebugIdentity(
    enabled: enabled ?? this.enabled,
    userId: userId ?? this.userId,
    savedIds: savedIds ?? this.savedIds,
  );
}

class TifoDebugIdentityController extends Notifier<TifoDebugIdentity> {
  static const String _boxName = 'tifo_debug';
  static const String _keyEnabled = 'identityEnabled';
  static const String _keyUserId = 'identityUserId';
  static const String _keySavedIds = 'identitySavedIds';

  /// Keeps the list usable as a picker rather than an archive.
  static const int _maxSaved = 20;

  @override
  TifoDebugIdentity build() {
    // Hive is async and `build` is not: start from "off" and adopt the stored
    // identity as soon as the box opens. A request fired in that window uses
    // the host session — acceptable for a debug tool, and the panel always
    // shows the restored state.
    detach(_restore(), tag: 'tifoDebugIdentity.restore');
    return const TifoDebugIdentity();
  }

  Future<void> _restore() async {
    try {
      final box = await ref.read(hiveProvider(_boxName).future);
      final saved = (box.get(_keySavedIds) as List?)?.map((e) => e.toString()).toList() ?? const <String>[];
      final identity = TifoDebugIdentity(
        enabled: box.get(_keyEnabled) == true,
        userId: box.get(_keyUserId)?.toString() ?? '',
        savedIds: saved,
      );
      state = identity;
      if (identity.isActive) {
        logger.log('[tifo] debug identity restored: acting as "${identity.userId}"');
      }
    } catch (error) {
      logger.log('[tifo] debug identity restore failed: $error');
    }
  }

  Future<void> _persist(TifoDebugIdentity identity) async {
    state = identity;
    try {
      final box = await ref.read(hiveProvider(_boxName).future);
      await box.putAll({
        _keyEnabled: identity.enabled,
        _keyUserId: identity.userId,
        _keySavedIds: identity.savedIds,
      });
    } catch (error) {
      logger.log('[tifo] debug identity persist failed: $error');
    }
  }

  /// Flips the override without losing the picked id, so a tester can bounce
  /// between their own account and the test user.
  Future<void> setEnabled({required bool enabled}) => _persist(state.copyWith(enabled: enabled));

  /// Acts as [id] from now on and remembers it. Blank input is ignored — it
  /// would silently mean "host session" while the switch still reads ON.
  Future<void> use(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final saved = [trimmed, ...state.savedIds.where((e) => e != trimmed)];
    logger.log('[tifo] debug identity: acting as "$trimmed"');
    await _persist(
      state.copyWith(
        enabled: true,
        userId: trimmed,
        savedIds: saved.length > _maxSaved ? saved.sublist(0, _maxSaved) : saved,
      ),
    );
  }

  /// Drops [id] from the saved list; if it was the active one, falls back to
  /// the host session rather than silently acting as a deleted user.
  Future<void> forget(String id) async {
    final saved = state.savedIds.where((e) => e != id).toList();
    final wasActive = state.userId == id;
    await _persist(
      TifoDebugIdentity(
        enabled: state.enabled && !wasActive,
        userId: wasActive ? '' : state.userId,
        savedIds: saved,
      ),
    );
  }
}

final tifoDebugIdentityProvider = NotifierProvider<TifoDebugIdentityController, TifoDebugIdentity>(
  TifoDebugIdentityController.new,
);
