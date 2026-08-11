import 'dart:async';

import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// The next gate the player must pass before they can play. BRD V2
/// (US-01 BR-01, US-02 AC-02): route to the first unmet step in the order
/// **tutorial → team selected**; a logged-out user goes to the TUTORIAL
/// first, login is required only to confirm a team. [ready] means the play
/// CTA goes straight to the game.
enum TifoJourneyStep { login, tutorial, teamSelect, ready }

@immutable
class TifoSessionState {
  const TifoSessionState({
    this.profile,
    this.clubs = const [],
    this.config = TifoGameConfig.fallback,
    this.isLoading = false,
    this.isGuest = true,
    this.error,
  });

  final TifoProfile? profile;
  final List<TifoClubInfo> clubs;
  final TifoGameConfig config;
  final bool isLoading;

  /// True while requests run on the guest device bearer (no host SSO login).
  /// Staging lazily registers a profile for any bearer, so [profile] being
  /// non-null does NOT mean the user is signed in — always gate on this.
  final bool isGuest;

  final String? error;

  TifoClubInfo? get myClub {
    final id = profile?.clubId;
    if (id == null) {
      return null;
    }
    for (final club in clubs) {
      if (club.id == id) {
        return club;
      }
    }
    return null;
  }

  TifoClubInfo? clubById(String? id) {
    for (final club in clubs) {
      if (club.id == id) {
        return club;
      }
    }
    return null;
  }

  /// BRD V2 gate order: tutorial first (even logged out), then login (it
  /// gates the team confirmation, US-04/BT-23), then team select → ready.
  TifoJourneyStep get nextStep {
    final p = profile;
    if (p == null || !p.tutorialCompleted) {
      return TifoJourneyStep.tutorial;
    }
    if (isGuest) {
      return TifoJourneyStep.login;
    }
    if (!p.hasClub) {
      return TifoJourneyStep.teamSelect;
    }
    return TifoJourneyStep.ready;
  }

  /// True once every play-gate is cleared (tutorial seen, logged in, club
  /// picked). Drives "Dominate with your team" — that pill targets players
  /// who still have a gate left, not just first-ever-launch users.
  bool get isPlayReady => nextStep == TifoJourneyStep.ready;

  TifoSessionState copyWith({
    TifoProfile? profile,
    List<TifoClubInfo>? clubs,
    TifoGameConfig? config,
    bool? isLoading,
    bool? isGuest,
    Object? error = _sentinel,
  }) => TifoSessionState(
    profile: profile ?? this.profile,
    clubs: clubs ?? this.clubs,
    config: config ?? this.config,
    isLoading: isLoading ?? this.isLoading,
    isGuest: isGuest ?? this.isGuest,
    error: identical(error, _sentinel) ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

/// Owns the player's TIFO session: profile (`/me`), season roster (`/clubs`)
/// and game config (`/config`). On staging `/me` lazily creates the profile,
/// so [load] doubles as sign-in.
class TifoSessionController extends Notifier<TifoSessionState> {
  String? _lastHostToken;

  @override
  TifoSessionState build() {
    // React to host auth changes. `EntryPointCubit.onLogin` returns as soon
    // as the login screen OPENS, so a "reload after openHostLogin()" runs
    // while the user is still signed out. Watch the cubit stream directly and
    // compare the LIVE token (`CommonProperties.token` reads the current
    // cubit state) so both login and logout reload the session the moment
    // they actually complete — the mapness tokenProvider cache is not
    // trusted, it can go stale across a logout.
    _lastHostToken = CommonProperties.token;
    final subscription = sl<EntryPointCubit>().stream.listen((_) {
      final token = CommonProperties.token;
      if (token == _lastHostToken) {
        return;
      }
      _lastHostToken = token;
      logger.log('[tifo] host auth changed (signed ${token.isEmpty ? 'out' : 'in'}) → reloading session');
      load();
    });
    ref.onDispose(subscription.cancel);
    return const TifoSessionState();
  }

  TifoApi get _api => ref.read(tifoApiProvider);

  /// Loads profile + roster + config. Safe to call repeatedly (refresh).
  ///
  /// The roster and config are public (guest bearer works), so they load even
  /// when `/me` fails — otherwise a signed-out user got raw club slugs and
  /// grey crests everywhere because the profile error aborted the whole load.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final isGuest = await _api.isGuestSession();
    TifoProfile? profile;
    String? error;
    try {
      profile = await _api.getMe();
    } catch (e) {
      error = e is TifoApiException ? e.message : e.toString();
    }
    try {
      final clubs = state.clubs.isEmpty ? await _api.getClubs() : state.clubs;
      final config = await _api.getConfig();
      state = state.copyWith(
        profile: profile,
        clubs: clubs,
        config: config,
        isLoading: false,
        isGuest: isGuest,
        error: error,
      );
    } catch (e) {
      state = state.copyWith(
        profile: profile,
        isLoading: false,
        isGuest: isGuest,
        error: error ?? (e is TifoApiException ? e.message : e.toString()),
      );
    }
    unawaited(_claimDailyAllowanceIfDue());
  }

  /// US-15: the daily allowance is an idempotent grant the CLIENT has to ask
  /// for — the backend never credits it on its own, so without this call the
  /// player simply never receives their daily tokens.
  ///
  /// Skipped for guests (US-15 needs a login) and when `/me` already says the
  /// grant landed for this game day, so a repeat `load()` costs no request.
  Future<void> _claimDailyAllowanceIfDue() async {
    final profile = state.profile;
    if (profile == null || state.isGuest || profile.dailyAllowanceGranted) {
      return;
    }
    try {
      final grant = await _api.claimDailyAllowance();
      if (grant.alreadyGranted || grant.dailyAllowance == 0) {
        return;
      }
      logger.log('[tifo] daily allowance +${grant.dailyAllowance} (balance ${grant.balance})');
      await refreshProfile();
    } catch (error) {
      // Non-fatal: the next load() retries. Never blocks opening the game.
      logger.log('[tifo] daily allowance failed: $error');
    }
  }

  Future<void> refreshProfile() async {
    try {
      state = state.copyWith(profile: await _api.getMe());
    } catch (_) {
      // Keep the stale profile; the next explicit load() surfaces errors.
    }
  }

  /// One-time season club pick (server grants the welcome bonus), then
  /// refreshes the profile so balance/club are current.
  Future<void> selectClub(String clubId) async {
    await _api.selectClub(clubId);
    await refreshProfile();
  }

  /// Marks the tutorial passed. BRD: *starting* the tutorial removes the gate
  /// forever, so call this on start (not completion) — skipping later must not
  /// re-gate the player.
  Future<void> markTutorialStarted() async {
    final p = state.profile;
    if (p == null || p.tutorialCompleted) {
      return;
    }
    try {
      await _api.completeTutorial();
      await refreshProfile();
    } catch (_) {
      // Non-fatal: the gate re-appears next session at worst.
    }
  }

  Future<void> markOnboardingCompleted() async {
    final p = state.profile;
    if (p == null || p.onboardingCompleted) {
      return;
    }
    try {
      await _api.completeOnboarding();
      await refreshProfile();
    } catch (_) {
      // Non-fatal.
    }
  }

  /// Called when the app language changes: [load] normally reuses `clubs`
  /// once loaded (`state.clubs.isEmpty ? … : state.clubs`), so a plain
  /// `load()` would keep serving club names in the old locale. Clearing the
  /// cached roster first forces a fresh `/clubs` fetch with the new locale.
  Future<void> forceRefresh() async {
    state = state.copyWith(clubs: const []);
    await load();
  }
}

final tifoSessionProvider = NotifierProvider<TifoSessionController, TifoSessionState>(TifoSessionController.new);
