import 'dart:async';

import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/shared/utils/detach.dart';
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
    this.hasLoaded = false,
    this.isGuest = true,
    this.error,
  });

  final TifoProfile? profile;
  final List<TifoClubInfo> clubs;
  final TifoGameConfig config;
  final bool isLoading;

  /// True once [TifoSessionController.load] has finished at least once
  /// (success OR failure). Before that the state is UNKNOWN, not "gates
  /// unmet": `profile` is null on a fresh build, so [nextStep] answers
  /// `tutorial` for everyone — including a fully onboarded player right after
  /// a relaunch. Any UI that decides what to show from the gate state has to
  /// wait for this flag (see [shouldOfferJoin]).
  final bool hasLoaded;

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
  /// picked).
  bool get isPlayReady => nextStep == TifoJourneyStep.ready;

  /// Whether to show the "Dominate with your team" pill: only for a SIGNED-IN
  /// player whose gate state is actually KNOWN and still has a gate left.
  ///
  /// * [hasLoaded] + non-null [profile] — [nextStep] cannot distinguish "not
  ///   loaded yet" / "`/me` failed" from "tutorial not done", since it reads a
  ///   null profile as the first gate. Without these the pill appeared over
  ///   the map on every relaunch for an onboarded player, and tapping it
  ///   merely forced the session load it was waiting on (which also repainted
  ///   the map). An unknown gate state shows no CTA rather than the wrong one.
  /// * `!isGuest` — the pill is not offered while signed out at all. Note this
  ///   makes [TifoJourneyStep.login] unreachable THROUGH THIS PILL by
  ///   construction; a signed-out player reaches the tutorial gate via the ⚽
  ///   entry popup's CTA instead, and `isGuest` (not `profile`) is the only
  ///   trustworthy sign-in signal — staging lazily registers a profile for
  ///   any bearer, guest bearers included.
  bool get shouldOfferJoin => hasLoaded && profile != null && !isGuest && !isPlayReady;

  TifoSessionState copyWith({
    TifoProfile? profile,
    List<TifoClubInfo>? clubs,
    TifoGameConfig? config,
    bool? isLoading,
    bool? hasLoaded,
    bool? isGuest,
    Object? error = _sentinel,
  }) => TifoSessionState(
    profile: profile ?? this.profile,
    clubs: clubs ?? this.clubs,
    config: config ?? this.config,
    isLoading: isLoading ?? this.isLoading,
    hasLoaded: hasLoaded ?? this.hasLoaded,
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
        hasLoaded: true,
        isGuest: isGuest,
        error: error,
      );
    } catch (e) {
      state = state.copyWith(
        profile: profile,
        isLoading: false,
        hasLoaded: true,
        isGuest: isGuest,
        error: error ?? (e is TifoApiException ? e.message : e.toString()),
      );
    }
    detach(_claimDailyAllowanceIfDue(), tag: 'tifoSessionProvider.claimDailyAllowanceIfDue');
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
  ///
  /// Returns whether the tutorial is RECORDED for this profile once this
  /// returns. The result matters (TFS 86055): the guided tour is an entirely
  /// local flow, so losing connectivity mid-tour doesn't interrupt it — the
  /// tour finishes, and only this call knows the server never heard about it.
  /// Swallowing that silently let the caller stamp its device flag anyway,
  /// which suppressed the tour forever while the server-side gate stayed shut.
  Future<bool> markTutorialStarted() async {
    if (state.profile?.tutorialCompleted == true) {
      return true; // already recorded
    }
    try {
      await _api.completeTutorial();
    } catch (error) {
      logger.log('[tifo] tutorial report failed, leaving the gate closed: $error');
      return false;
    }
    // Refreshed for the balance and flags the rest of the UI reads — but the
    // record above is what counts, not this. Kept in its own try/catch: `/me`
    // legitimately 401s while the player is still a guest (same reason
    // `load()` tolerates it — see its doc comment), and that must not be
    // mistaken for the completion POST having failed. It previously WAS
    // gated on `tutorialCompleted` coming back true and that reported
    // failure on a perfectly good connection whenever `/me` hadn't caught up
    // with the POST yet: the request having succeeded IS the record. Same
    // reason the `profile == null` early-return is gone — it made "the
    // profile isn't loaded yet" indistinguishable from "the server refused".
    try {
      await refreshProfile();
    } catch (error) {
      logger.log('[tifo] profile refresh after tutorial-complete failed (expected while guest): $error');
    }
    return true;
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
