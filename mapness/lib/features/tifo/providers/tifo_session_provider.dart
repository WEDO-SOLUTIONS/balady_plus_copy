import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

/// The next gate the player must pass before they can play (BRD US-02:
/// "logged in, has started the tutorial, and has selected a team", routed in
/// that order). [ready] means the play CTA goes straight to the game.
enum TifoJourneyStep { login, tutorial, teamSelect, ready }

@immutable
class TifoSessionState {
  const TifoSessionState({
    this.profile,
    this.clubs = const [],
    this.config = TifoGameConfig.fallback,
    this.isLoading = false,
    this.error,
  });

  final TifoProfile? profile;
  final List<TifoClubInfo> clubs;
  final TifoGameConfig config;
  final bool isLoading;
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

  /// BRD gate order: login → tutorial → team select → ready.
  TifoJourneyStep get nextStep {
    final p = profile;
    if (p == null) {
      return TifoJourneyStep.login;
    }
    if (!p.tutorialCompleted) {
      return TifoJourneyStep.tutorial;
    }
    if (!p.hasClub) {
      return TifoJourneyStep.teamSelect;
    }
    return TifoJourneyStep.ready;
  }

  TifoSessionState copyWith({
    TifoProfile? profile,
    List<TifoClubInfo>? clubs,
    TifoGameConfig? config,
    bool? isLoading,
    Object? error = _sentinel,
  }) => TifoSessionState(
    profile: profile ?? this.profile,
    clubs: clubs ?? this.clubs,
    config: config ?? this.config,
    isLoading: isLoading ?? this.isLoading,
    error: identical(error, _sentinel) ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

/// Owns the player's TIFO session: profile (`/me`), season roster (`/clubs`)
/// and game config (`/config`). On staging `/me` lazily creates the profile,
/// so [load] doubles as sign-in.
class TifoSessionController extends Notifier<TifoSessionState> {
  @override
  TifoSessionState build() => const TifoSessionState();

  TifoApi get _api => ref.read(tifoApiProvider);

  /// Loads profile + roster + config. Safe to call repeatedly (refresh).
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _api.getMe();
      final clubs = state.clubs.isEmpty ? await _api.getClubs() : state.clubs;
      final config = await _api.getConfig();
      state = state.copyWith(profile: profile, clubs: clubs, config: config, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e is TifoApiException ? e.message : e.toString());
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
}

final tifoSessionProvider = NotifierProvider<TifoSessionController, TifoSessionState>(TifoSessionController.new);
