import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';
import 'package:mapness/features/tifo/data/tifo_activity_log.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_debug_collider_overlay.dart';
import 'package:mapness/features/tifo/data/tifo_debug_color_override.dart';
import 'package:mapness/features/tifo/data/tifo_debug_goalkeeper_difficulty.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart';
import 'package:mapness/features/tifo/penalty/penalty_result_screen.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_poller.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Which call-to-action the building sheet shows, and therefore whether the
/// sheet is refusing a play intent at all.
enum TifoBuildingCta {
  play,

  /// The player's own club already holds this building (the server 409s).
  ownBuilding,

  notPlayReady,

  /// Someone else has a live session on it ("Hold on…").
  live,

  cooldown,
}

/// Why `play/start` failed, as far as the sheet needs to tell the player.
enum _StartFailure { locked, ownBuilding, noTokens, other }

/// Derives the sheet's CTA state. Pure on purpose: `build()` renders it and
/// `tifo_blocked` reports it, so the event can never disagree with what the
/// player is actually looking at.
TifoBuildingCta tifoBuildingCta({
  required TifoBuilding building,
  required bool isPlayReady,
  required String? myClubId,
}) {
  final isOwnBuilding = building.ownerClubSlug != null && building.ownerClubSlug == myClubId;
  if (isOwnBuilding) {
    return TifoBuildingCta.ownBuilding;
  }
  if (building.isAvailable) {
    return isPlayReady ? TifoBuildingCta.play : TifoBuildingCta.notPlayReady;
  }
  return building.status == 'live' ? TifoBuildingCta.live : TifoBuildingCta.cooldown;
}

/// Opens the capture sheet for [building] on the root navigator, so it floats
/// above the map regardless of who triggered it (a polygon tap from the map
/// layer, which isn't a widget). Rebuilt to the Figma light "building details"
/// sheet (BRD US-08), with the three status states (available / live /
/// cooldown).
Future<void> showTifoBuildingSheet(BuildContext context, TifoBuilding building) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: context.themeRead.colors.backgroundSurface1,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => _TifoBuildingSheet(building: building),
);

class _TifoBuildingSheet extends ConsumerStatefulWidget {
  const _TifoBuildingSheet({required this.building});

  final TifoBuilding building;

  @override
  ConsumerState<_TifoBuildingSheet> createState() => _TifoBuildingSheetState();
}

class _TifoBuildingSheetState extends ConsumerState<_TifoBuildingSheet> {
  bool _isBusy = false;
  String? _error;

  /// Phase the current shootout run is in, for `tifo_play_exit`.
  TifoPlayPhase _playPhase = TifoPlayPhase.aiming;

  /// Exactly one `tifo_play_exit` per shootout run. Reset in [_runShootout];
  /// this call site is the only place that knows where a run begins and ends,
  /// which is why the guard lives here and not in `TifoEvents`.
  bool _playExitReported = true;

  /// Captured before the sheet is popped so the post-game submit (which runs
  /// after this State is disposed) can still read providers.
  ProviderContainer? _container;

  /// Snapshot taken when the sheet was opened. The play/submit path reads it
  /// AFTER this State is disposed (post-game submit) and deliberately wants
  /// the pre-capture values (e.g. the owner BEFORE this attempt on the result
  /// screen) — keep it frozen; `build()` renders the live cache entry instead.
  TifoBuilding get _building => widget.building;

  @override
  void initState() {
    super.initState();
    // Once per sheet open: a sheet that opens with its CTA already disabled is
    // the UI refusing a play intent before the player even taps.
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportOpenBlock());
  }

  /// `tifo_blocked` for a sheet that cannot be played right now. Only the two mechanics states
  /// are reported — `notPlayReady` is an unmet gate already reported by the gate walk, and
  /// `ownBuilding` is a rule, not friction.
  void _reportOpenBlock() {
    if (!mounted) {
      return;
    }
    final session = ref.read(tifoSessionProvider);
    final live = ref.read(tifoBuildingsProvider).byId[widget.building.id] ?? widget.building;
    final cta = tifoBuildingCta(building: live, isPlayReady: session.isPlayReady, myClubId: session.myClub?.id);
    switch (cta) {
      case TifoBuildingCta.cooldown:
        unawaited(TifoEvents.blocked(reason: TifoBlockReason.cooldown, surface: TifoSurface.building));
      case TifoBuildingCta.live:
        unawaited(TifoEvents.blocked(reason: TifoBlockReason.buildingLocked, surface: TifoSurface.building));
      case TifoBuildingCta.play:
      case TifoBuildingCta.ownBuilding:
      case TifoBuildingCta.notPlayReady:
        break;
    }
  }

  /// Reports how this shootout run ended, once. [_playPhase] is whatever the run had reached.
  /// [outcome] is the server's verdict — known only for the natural end (see [_submit]);
  /// every other exit leaves before it answers.
  void _reportPlayExit(TifoPlayExitReason reason, {TifoPlayOutcome? outcome}) {
    if (_playExitReported) {
      return;
    }
    _playExitReported = true;
    TifoEvents.playExit(phase: _playPhase, reason: reason, outcome: outcome);
  }

  /// The API's verdict as the analytics enum. [TifoOutcome.unknown] (an unrecognized string)
  /// maps to null so the property is omitted, rather than folded into `voided` and read as a
  /// server-side void that never happened.
  static TifoPlayOutcome? _analyticsOutcome(TifoOutcome outcome) => switch (outcome) {
    TifoOutcome.claimed => TifoPlayOutcome.claimed,
    TifoOutcome.taken => TifoPlayOutcome.taken,
    TifoOutcome.failed => TifoPlayOutcome.failed,
    TifoOutcome.voided => TifoPlayOutcome.voided,
    TifoOutcome.unknown => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(tifoSessionProvider);
    // Live cache entry for this building: the poller and the post-capture
    // optimistic update land in `tifoBuildingsProvider`, so score/status/
    // standing shown here follow them while the sheet is open (BALADY-3877).
    // Falls back to the open-time snapshot if the entry was evicted.
    final live = ref.watch(tifoBuildingsProvider.select((s) => s.byId[widget.building.id])) ?? widget.building;
    final ownerClub = session.clubById(live.ownerClubSlug);
    final ownerColor = ownerClub == null ? TifoColors.neutralFill : Color(ownerClub.colorArgb);
    final isClaim = live.isNeutral;
    // BRD US-08: browsing is always allowed, but a player who hasn't cleared
    // the play-gate yet (e.g. "Maybe Later" on team select) can't start a
    // challenge — show that up front instead of letting them tap Challenge
    // and hit a gate failure.
    final canChallenge = session.isPlayReady;
    // The server 409s `play/start` for a building the player's own club
    // already holds — used to only surface after the game had already
    // opened and closed again. Block the CTA up front instead.
    final isOwnBuilding = live.ownerClubSlug != null && live.ownerClubSlug == session.myClub?.id;
    final standingDays = live.standingDays;
    final cta = tifoBuildingCta(building: live, isPlayReady: canChallenge, myClubId: session.myClub?.id);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: context.colors.foregroundMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.claimTheBuilding,
                      style: TifoText.h2.copyWith(color: context.colors.foregroundDefault),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                _CloseBtn(onTap: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: 16),

            // Owner / unclaimed
            _card(
              child: isClaim
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.tifoUnclaimed, style: TifoText.h2.copyWith(color: context.colors.accentDefault)),
                        const SizedBox(height: 24),
                        Text(
                          l10n.tifoNotClaimedYet,
                          style: TifoText.captionRegular.copyWith(color: context.colors.accentDefault),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.tifoCurrentOwner, style: TifoText.captionMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: ownerColor, borderRadius: BorderRadius.circular(12)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ownerClub?.name ?? live.displayName,
                                    style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
                                  ),
                                  // TFS 86073: the design carries the current
                                  // standing's age under the owner's name (see
                                  // `TifoDemoBuildingSheet`, and the same row on
                                  // the district sheet) — the real sheet was
                                  // rendering the crest and the name only.
                                  // Hidden rather than zeroed when the payload
                                  // doesn't carry it; see
                                  // `TifoBuilding.standingDays`.
                                  if (standingDays != null)
                                    Text(
                                      standingDays == 0
                                          // "Since 0 days ago" reads as a
                                          // formatting bug on a building claimed
                                          // minutes ago.
                                          ? l10n.tifoJustNow
                                          : '${l10n.tifoSince} ${tifoStandingDaysAgo(context, standingDays)}',
                                      style: TifoText.captionRegular,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),

            // Current score to beat
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.tifoCurrentScoreToBeat, style: TifoText.captionMedium),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isClaim ? 0 : live.scoreToBeat}',
                        style: TifoText.h2.copyWith(color: TifoColors.accentSoft),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(l10n.tifoGoals, style: TifoText.captionRegular),
                      ),
                      const Spacer(),
                      const Text('⚽', style: TextStyle(fontSize: 30)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Contested (7d)
            _card(
              child: Row(
                children: [
                  Text(
                    '${live.contested7d}',
                    style: TifoText.h3.copyWith(color: context.colors.foregroundDefault),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.tifoContestedCount(live.contested7d),
                      style: TifoText.captionRegular,
                    ),
                  ),
                ],
              ),
            ),

            if (live.isAvailable && !isOwnBuilding) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TifoRadii.ml),
                  border: Border.all(color: context.colors.extra01Active),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, size: 18, color: context.colors.extra01Active),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isClaim ? l10n.tifoClaimHint : l10n.tifoChallengeHint,
                        style: TifoText.captionMedium.copyWith(color: context.colors.extra01Active),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Color(0xFFE5484D), fontSize: 13)),
            ],
            const SizedBox(height: 20),

            // CTA by status — one derivation, shared with `tifo_blocked` so
            // the event can never disagree with the button on screen.
            switch (cta) {
              TifoBuildingCta.play => TifoPrimaryButton(
                label: isClaim ? l10n.tifoClaimBuilding : l10n.tifoChallenge,
                leadingEmoji: '⚽',
                busy: _isBusy,
                onPressed: _isBusy ? null : _onPlayPressed,
              ),
              TifoBuildingCta.ownBuilding => _disabledBar(l10n.tifoOwnBuildingHint),
              TifoBuildingCta.notPlayReady => _disabledBar(l10n.tifoNotPlayReady),
              TifoBuildingCta.live => _disabledBar(l10n.tifoBuildingLiveHint),
              TifoBuildingCta.cooldown => _disabledBar(l10n.tifoBuildingCooldownHint),
            },
            if (kDebugMode) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TifoColors.amber,
                    side: const BorderSide(color: Color(0x33D9A400)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: (live.isAvailable && !_isBusy && !isOwnBuilding) ? _mockCapture : null,
                  icon: const Icon(Icons.bolt_rounded, size: 18),
                  label: const Text('Mock capture (skip game)'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      border: Border.all(color: TifoColors.border),
    ),
    child: child,
  );

  Widget _disabledBar(String message) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: context.colors.foregroundSoft,
      borderRadius: BorderRadius.circular(TifoRadii.l),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TifoBallIcon(size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TifoText.button.copyWith(fontSize: 14),
          ),
        ),
      ],
    ),
  );

  /// Runs the BRD play-gate (login → tutorial → team) before starting. If the
  /// player isn't ready and doesn't complete the gate, we stop.
  Future<void> _onPlayPressed() async {
    _container = ProviderScope.containerOf(context, listen: false);
    setState(() {
      _isBusy = true;
      _error = null;
    });

    final ready = await TifoJourney(ref).ensurePlayReady(context, source: TifoActivationSource.buildingSheet);
    if (!mounted) {
      return;
    }
    if (!ready) {
      // Surface WHY: the gate walk bails silently (cancelled login, skipped
      // tutorial, "Maybe Later"), and a button that just goes quiet reads as
      // "Challenge / mock capture is broken". The unmet step is logged for
      // debugging; the CTA is already hidden/disabled for this case (see
      // `canChallenge` in build()), so a real user only hits this branch if
      // their play-ready status changed mid-gate — a friendly message is enough.
      logger.log('[tifo] play-gate bailed: unmet step=${ref.read(tifoSessionProvider).nextStep.name}');
      if (!mounted) {
        return;
      }
      setState(() {
        _isBusy = false;
        _error = AppLocalizations.of(context).tifoNotPlayReady;
      });
      return;
    }

    final session = ref.read(tifoSessionProvider);
    if ((session.profile?.balance ?? 0) < session.config.challengeCost) {
      unawaited(TifoEvents.blocked(reason: TifoBlockReason.noTokens, surface: TifoSurface.building));
      setState(() => _isBusy = false);
      final l10n = AppLocalizations.of(context);
      unawaited(
        showTifoMessageDialog<void>(
          context,
          card: TifoMessageCard(
            showIllustration: true,
            title: l10n.tifoNotEnoughTokensTitle,
            body: l10n.tifoNotEnoughTokensBody,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
      return;
    }

    await _startAndPlay();
  }

  /// Opens the game first and the server session only once the pitch is ready.
  ///
  /// The session's expiry window is short (`liveLockTimeoutSeconds` = 30 on
  /// staging) and a session that outlives it resolves as `voided` with the
  /// token spent — so every second of asset loading used to eat into the
  /// player's shooting time. Starting the session on the game's `onReady`
  /// keeps loading out of that window; input stays locked until it's open.
  Future<void> _startAndPlay() async {
    _container ??= ProviderScope.containerOf(context, listen: false);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(); // close the sheet
    _runShootout();
  }

  void _runShootout() {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) {
      return;
    }
    // A new run: arm the one-shot `tifo_play_exit` guard.
    _playExitReported = false;
    _playPhase = TifoPlayPhase.aiming;
    final container = _container!;
    final session = container.read(tifoSessionProvider);
    final missesAllowed = session.config.missesAllowed;
    // Goalkeeper wears the building's owning club's color (default/Green for
    // a neutral or unresolvable building); striker wears the player's own
    // club color (default/White if the player has none or it doesn't match
    // a known bucket) — see tifoNearestKeeperColor/tifoNearestStrikerColor.
    // Debug panel can pin either side to a fixed bucket for testing; off (the
    // default, and always off in production) leaves this untouched.
    final colorOverride = container.read(tifoDebugColorOverrideProvider);
    final keeperColor = colorOverride.enabled && colorOverride.keeperColor != null
        ? colorOverride.keeperColor
        : (_building.isNeutral ? null : tifoNearestKeeperColor(session.clubById(_building.ownerClubSlug)?.colorArgb));
    final strikerColor = colorOverride.enabled && colorOverride.strikerColor != null
        ? colorOverride.strikerColor
        : tifoNearestStrikerColor(session.myClub?.colorArgb);
    TifoPlaySession? playSession;
    // The map layer stays enabled (and its 20s ownership poller with it) for
    // the whole session — pause just the poller while the fullscreen game is
    // up so its bridge calls don't compete with Flame's per-frame rendering.
    container.read(tifoBuildingsPollerProvider.notifier).stop();
    var handled = false;
    late final MaterialPageRoute<void> route;
    unawaited(
      navigator.push<void>(
        route = MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => PenaltyApp(
            missesAllowed: missesAllowed,
            scoreToBeat: _building.scoreToBeat,
            strikerColor: strikerColor,
            keeperColor: keeperColor,
            showColliderDebug: container.read(tifoDebugColliderOverlayProvider),
            goalkeeperDifficulty: container.read(tifoDebugGoalkeeperDifficultyProvider),
            sessionTimeoutSeconds: session.config.liveLockTimeoutSeconds,
            locale: container.read(appLanguageProvider).locale,
            // The player left the pitch. Reported immediately with the phase
            // the run had reached; the guard then keeps a later natural end
            // from reporting a second time.
            onBackgrounded: () => _reportPlayExit(TifoPlayExitReason.backgrounded),
            onReady: (arm) => unawaited(
              _openSession(container, route).then((session) {
                if (session == null) {
                  return; // start failed — the game route is already gone
                }
                // TFS 86713: the player left the pitch (X or system back)
                // while play/start was in flight. The token is spent and the
                // building stays live-locked until the server timeout, so the
                // next Challenge on it within that window got a 409 that
                // surfaced as a random "Something went wrong". Close the
                // session right away instead of leaving it dangling.
                if (handled || !route.isActive) {
                  handled = true;
                  unawaited(_releaseAbandonedSession(container, session, missesAllowed));
                  return;
                }
                playSession = session;
                arm();
              }),
            ),
            // TFS 86075: the session is void the moment the device goes
            // offline (the backend keeps the token for a session that outlives
            // `expiresAt`), so stop the run instead of letting the player play
            // out something that cannot be submitted, then reconnect and find
            // out. Shares `handled` with `onComplete` so the two can't both
            // fire. No submit: there is no network, and the server has already
            // written the session off — `tifoConnectionLostBody` says exactly
            // that ("the session was canceled and your token was not
            // refunded"), which is why FR-16 has that string.
            onConnectionLost: () {
              if (handled) {
                return;
              }
              handled = true;
              logger.log('[tifo] shootout abandoned: device went offline mid-session');
              _reportPlayExit(TifoPlayExitReason.connectionLost);
              container.read(tifoBuildingsPollerProvider.notifier).start();
              _closeGameRoute(route);
              _showResult('connection lost mid-shootout', connectionLost: true);
            },
            onComplete: (outcome) {
              if (handled) {
                return;
              }
              final session = playSession;
              if (session == null) {
                // Forfeited (X → Leave) before play/start answered: nothing to
                // submit yet. Leave the pitch now; `onReady` releases the
                // session if it still opens (see above). Previously this
                // returned silently and left the player on a dead pitch.
                handled = true;
                _reportPlayExit(TifoPlayExitReason.userQuit);
                container.read(tifoBuildingsPollerProvider.notifier).start();
                _closeGameRoute(route);
                return;
              }
              handled = true;
              // A forfeited run ends HERE — the submit and result screen that
              // follow are bookkeeping, not play. A natural end is reported as
              // `completed` once the result hero is actually up (see [_submit]).
              switch (outcome.end) {
                case TifoShootoutEnd.forfeitExit:
                  _reportPlayExit(TifoPlayExitReason.userQuit);
                case TifoShootoutEnd.forfeitAfk:
                  _reportPlayExit(TifoPlayExitReason.timeout);
                case TifoShootoutEnd.connectionLost:
                  _reportPlayExit(TifoPlayExitReason.connectionLost);
                case TifoShootoutEnd.completed:
                  break;
              }
              container.read(tifoBuildingsPollerProvider.notifier).start();
              // Short beat so the last GOAL!/MISS! flash is readable, then
              // submit — kept tight because the clock is still running.
              Future<void>.delayed(const Duration(seconds: 2), () {
                _closeGameRoute(route);
                unawaited(_submit(playSession: session, outcome: outcome));
              });
            },
          ),
        ),
      ),
    );
  }

  /// Deducts the token and opens the session. On failure the game route is
  /// closed and the reason is shown — the player never gets a pitch they
  /// can't legally kick on.
  Future<TifoPlaySession?> _openSession(ProviderContainer container, Route<void> gameRoute) async {
    try {
      final session = await container.read(tifoApiProvider).startPlay(_building.id);
      // Token was just spent; refresh the balance shown elsewhere.
      unawaited(container.read(tifoSessionProvider.notifier).refreshProfile());
      return session;
    } catch (e) {
      // `_runShootout` paused the poller for the game; without this a failed
      // start left it off for the rest of the app session, so building
      // statuses went stale and the next Challenge hit the same refusal.
      container.read(tifoBuildingsPollerProvider.notifier).start();
      final wasOnPitch = gameRoute.isActive;
      _closeGameRoute(gameRoute);
      final code = e is TifoApiException ? e.statusCode : null;
      final message = e is TifoApiException ? e.message : e.toString();
      final detail = 'play/start failed ($code): $message';
      if (!wasOnPitch) {
        // The player already left; don't pop a dialog over whatever is there now.
        logger.log('[tifo] $detail (pitch already closed, not shown)');
        return null;
      }
      final failure = _classifyStartFailure(e);
      switch (failure) {
        case _StartFailure.locked:
        case _StartFailure.ownBuilding:
          // The cached status was stale (the poller is paused while a game is
          // up and only runs every 20 s): someone is playing this building, or
          // the player's club already took it. Say that instead of a generic
          // error, and pull fresh statuses so the sheet shows it next time.
          unawaited(container.read(tifoBuildingsProvider.notifier).refreshVisible());
          _showStartRefused(detail, ownBuilding: failure == _StartFailure.ownBuilding);
        case _StartFailure.noTokens:
          unawaited(container.read(tifoSessionProvider.notifier).refreshProfile());
          _showStartRefused(detail, noTokens: true);
        case _StartFailure.other:
          _showResult(detail, onRetry: _retryPlay);
      }
      return null;
    }
  }

  /// Closes exactly the game route — never whatever happens to be on top.
  ///
  /// Every exit used to be a bare `rootNavigatorKey.currentState?.pop()`: with
  /// the "Leave challenge?" / "Still playing?" sheet open that closed the sheet
  /// and left the game up under the error, and after a system back it popped
  /// the route BELOW the game (the map/landing).
  void _closeGameRoute(Route<void> route) {
    if (!route.isActive) {
      return;
    }
    final navigator = route.navigator;
    if (route.isCurrent) {
      navigator?.pop();
    } else {
      navigator?.removeRoute(route);
    }
  }

  /// Ends a session nobody is playing on (see `onReady` in [_runShootout]):
  /// submits a zero-goal run padded to [missesAllowed] misses — the only shape
  /// the backend accepts — which releases the live-lock. Silent on purpose:
  /// the player already chose to leave.
  Future<void> _releaseAbandonedSession(
    ProviderContainer container,
    TifoPlaySession session,
    int missesAllowed,
  ) async {
    container.read(tifoBuildingsPollerProvider.notifier).start();
    logger.log('[tifo] releasing abandoned session ${session.sessionId} on ${_building.id}');
    try {
      await container
          .read(tifoApiProvider)
          .submitPlay(
            buildingId: _building.id,
            sessionId: session.sessionId,
            score: 0,
            events: [
              for (var i = 0; i < missesAllowed; i++) TifoKickEvent(index: i, scored: false, atMs: 0).toJson(),
            ],
          );
    } catch (e) {
      // Nothing to show: the server times the lock out on its own.
      logger.log('[tifo] releasing abandoned session failed: $e');
    }
    unawaited(container.read(tifoSessionProvider.notifier).refreshProfile());
  }

  /// "Retry" from the failure sheet. The building sheet is long gone by then
  /// (it closes before the game opens), so this can't go through
  /// [_onPlayPressed] — that touched `context`/`setState` on a disposed State
  /// and threw, i.e. Retry only ever closed the dialog. The gate walk already
  /// passed for this run; the server re-checks the balance on play/start.
  void _retryPlay() {
    if (_container == null) {
      return;
    }
    _runShootout();
  }

  static _StartFailure _classifyStartFailure(Object e) {
    if (e is! TifoApiException) {
      return _StartFailure.other;
    }
    final message = e.message.toLowerCase();
    if (e.statusCode == 402 || message.contains('insufficient') || message.contains('not enough')) {
      return _StartFailure.noTokens;
    }
    if (e.statusCode == 409 || e.statusCode == 423) {
      return message.contains('already') || message.contains('own') ? _StartFailure.ownBuilding : _StartFailure.locked;
    }
    return _StartFailure.other;
  }

  /// A play/start the server refused for a game reason — not an error, so no
  /// Retry: retrying immediately gets the same answer.
  void _showStartRefused(String detail, {bool ownBuilding = false, bool noTokens = false}) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      return;
    }
    logger.log('[tifo] play/start refused: $detail');
    // Own building is a rule, not friction — `_reportOpenBlock` skips it too.
    if (!ownBuilding) {
      unawaited(
        TifoEvents.blocked(
          reason: noTokens ? TifoBlockReason.noTokens : TifoBlockReason.buildingLocked,
          surface: TifoSurface.building,
        ),
      );
    }
    final l10n = AppLocalizations.of(ctx);
    unawaited(
      showTifoMessageDialog<void>(
        ctx,
        card: TifoMessageCard(
          showIllustration: true,
          title: noTokens
              ? l10n.tifoNotEnoughTokensTitle
              : (ownBuilding ? l10n.tifoOwnBuildingHint : l10n.tifoBuildingLiveHint),
          body: noTokens ? l10n.tifoNotEnoughTokensBody : '',
          onClose: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  Future<void> _submit({required TifoPlaySession playSession, required TifoShootoutOutcome outcome}) async {
    // Reads go through the captured container: by the time the post-game submit
    // fires, this State is already disposed and `ref` would throw.
    final container = _container ?? ProviderScope.containerOf(rootNavigatorKey.currentContext!, listen: false);
    final api = container.read(tifoApiProvider);
    // TifoApi owns a private Dio, so these calls don't show up in the app's
    // http logger — log the submit here or the capture loop is invisible.
    // The kick log is spelled out (g = goal, m = miss): the backend rejects a
    // session that doesn't end on the allowed miss, and without seeing the
    // sequence a "voided again" report is unreadable.
    _playPhase = TifoPlayPhase.resultPending;
    final kicks = outcome.events.map((e) => e.scored ? 'g' : 'm').join();
    logger.log(
      '[tifo] submit ${_building.id}: score=${outcome.goals} misses=${outcome.misses} '
      'kicks=$kicks scoreToBeat=${_building.scoreToBeat}',
    );
    try {
      final result = await api.submitPlay(
        buildingId: _building.id,
        sessionId: playSession.sessionId,
        score: outcome.goals,
        events: outcome.events.map((e) => e.toJson()).toList(),
      );
      logger.log('[tifo] submit result: outcome=${result.outcome.name} yourScore=${result.yourScore}');
      // `voided`/`unknown` aren't a played-and-scored match (expired session,
      // server rejection) — Matches Played (`/me` stats) doesn't count them
      // either, so the local activity log shouldn't log them as a win/loss.
      if (result.outcome == TifoOutcome.claimed ||
          result.outcome == TifoOutcome.taken ||
          result.outcome == TifoOutcome.failed) {
        unawaited(
          container
              .read(tifoActivityLogProvider.notifier)
              .add(
                TifoActivityEntry(
                  type: result.isWin ? TifoActivityType.win : TifoActivityType.loss,
                  timestamp: DateTime.now(),
                ),
              ),
        );
      }
      // Reflect capture immediately using the player's own club; the next
      // viewport refresh reconciles from the server regardless.
      if (result.isWin) {
        final myClub = container.read(tifoSessionProvider).myClub;
        if (myClub != null) {
          container
              .read(tifoBuildingsProvider.notifier)
              .applyOwnership(
                buildingId: _building.id,
                clubSlug: myClub.id,
                savedScore: result.yourScore,
              );
        }
      }
      unawaited(container.read(tifoSessionProvider.notifier).refreshProfile());
      // Fullscreen Win/Loss/voided hero (US-14); errors keep the small dialog.
      _reportPlayExit(TifoPlayExitReason.completed, outcome: _analyticsOutcome(result.outcome));
      _showResultHero(container, result);
    } catch (e) {
      final message = e is TifoApiException ? e.message : e.toString();
      // The backend voids a session that outlived `expiresAt` and keeps the
      // token (FR-16).
      final expired = message.toLowerCase().contains('expired');
      if (expired) {
        // The backend voided a session that outlived `expiresAt` — the client
        // half of the same story `tifo_play_exit` exists to tell.
        _reportPlayExit(TifoPlayExitReason.timeout);
        logger.log('[tifo] submit rejected, session expired: $message');
        // The player DID finish the match — typically after the app sat in the
        // background past the 30 s live-lock and they tapped "Continue" on the
        // "Still playing?" prompt. A "Connection lost" sheet over the map for
        // that read as a network bug (TIFO QA: "connection error after
        // resuming from 30 min idle"). BRD FR-17 defines only two results —
        // captured or not captured — and a voided session captures nothing,
        // so show the regular loss hero ("So close!").
        _showResultHero(container, TifoPlayResult(outcome: TifoOutcome.voided, yourScore: outcome.goals));
        return;
      }
      logger.log('[tifo] submit failed${expired ? ' (session expired)' : ''}: $message');
      _showResult('Submit failed: $message', connectionLost: expired, onRetry: _retryPlay);
    }
  }

  /// Fullscreen Win/Loss hero (US-14) for [result], on the root navigator.
  void _showResultHero(ProviderContainer container, TifoPlayResult result) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      _playPhase = TifoPlayPhase.resultShown;
      unawaited(
        showTifoPenaltyResult(
          ctx,
          result,
          winnerColorKey: tifoResultColorKeyFor(container.read(tifoSessionProvider).myClub?.id),
          // Building's owner BEFORE this attempt — `applyOwnership` above only
          // mutates `tifoBuildingsProvider`'s map, not this widget's own
          // `_building` field, so this still reads the pre-capture value.
          buildingOwnerColorKeyBeforePlay: tifoResultColorKeyFor(_building.ownerClubSlug),
        ).whenComplete(() {
          // TFS 86070. The `refreshProfile()` above races the hero: it is
          // fired the moment the submit returns, so whether the new score and
          // match count have landed by the time the player dismisses the hero
          // depends on how fast `/me` answers — and on the backend having
          // committed the result before it was asked. Asking again ON
          // DISMISSAL is what makes the Profile tiles right when the player
          // actually looks at them. `container` (not `ref`) on purpose: this
          // fires after the sheet may be gone.
          unawaited(container.read(tifoSessionProvider.notifier).refreshProfile());
        }),
      );
    }
  }

  /// Debug-only: run the full server capture loop (play/start → play) with a
  /// synthetic winning event log, skipping the penalty mini-game. The backend
  /// still validates the events, so this exercises the real anti-cheat path.
  /// Kept mounted through the submit (no pre-pop) so `ref`/container stay valid.
  Future<void> _mockCapture() async {
    _container = ProviderScope.containerOf(context, listen: false);
    setState(() {
      _isBusy = true;
      _error = null;
    });

    // Make sure the player is play-ready (logged in + team) — the server
    // rejects a start otherwise.
    final ready = await TifoJourney(ref).ensurePlayReady(context, source: TifoActivationSource.buildingSheet);
    if (!mounted) {
      return;
    }
    if (!ready) {
      // Surface WHY: the gate walk bails silently (cancelled login, skipped
      // tutorial, "Maybe Later"), and a button that just goes quiet reads as
      // "Challenge / mock capture is broken". The unmet step is logged for
      // debugging; the CTA is already hidden/disabled for this case (see
      // `canChallenge` in build()), so a real user only hits this branch if
      // their play-ready status changed mid-gate — a friendly message is enough.
      logger.log('[tifo] play-gate bailed: unmet step=${ref.read(tifoSessionProvider).nextStep.name}');
      if (!mounted) {
        return;
      }
      setState(() {
        _isBusy = false;
        _error = AppLocalizations.of(context).tifoNotPlayReady;
      });
      return;
    }

    final resultCtx = rootNavigatorKey.currentContext;
    if (resultCtx != null) {
      unawaited(
        precacheTifoResultImages(
          resultCtx,
          winnerColorKey: tifoResultColorKeyFor(ref.read(tifoSessionProvider).myClub?.id),
          buildingOwnerColorKey: tifoResultColorKeyFor(_building.ownerClubSlug),
        ),
      );
    }
    final api = ref.read(tifoApiProvider);
    // Debug shortcut: no shootout ran, so no `tifo_play_exit` for it.
    _playExitReported = true;
    try {
      final playSession = await api.startPlay(_building.id);
      // Enough goals to win: claim needs ≥1; challenge needs > scoreToBeat.
      final winScore = _building.isNeutral ? 1 : _building.scoreToBeat + 1;
      final events = <TifoKickEvent>[
        for (var i = 0; i < winScore; i++) TifoKickEvent(index: i, scored: true, atMs: i * 800),
        // Three misses end the session (matches missesAllowed default).
        for (var i = 0; i < 3; i++) TifoKickEvent(index: winScore + i, scored: false, atMs: (winScore + i) * 800),
      ];
      final outcome = TifoShootoutOutcome(goals: winScore, misses: 3, events: events);
      await _submit(playSession: playSession, outcome: outcome);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBusy = false;
          _error = e is TifoApiException ? '${e.statusCode}: ${e.message}' : e.toString();
        });
      }
    }
  }

  /// Error feedback via a dialog on the root navigator — the map/landing
  /// route has no Scaffold, so a ScaffoldMessenger snackbar asserts. Win/Loss
  /// has its own fullscreen hero (US-14, [showTifoPenaltyResult]); this is
  /// only ever the failure path — see the "Connection lost" (session voided,
  /// FR-16) and generic "Something went wrong" Figma message states.
  /// [detail] is for the LOG, not the dialog: it carries the backend's own
  /// wording (and prefixes like "Submit failed:"), which is English-only and
  /// technical — it was being rendered straight into the sheet, so an Arabic
  /// build showed raw English and an EN build showed server internals. The
  /// body now always comes from l10n; `tifoSomethingWentWrongBody` exists for
  /// exactly this.
  void _showResult(String detail, {bool connectionLost = false, VoidCallback? onRetry}) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      return;
    }
    logger.log('[tifo] showing failure dialog${connectionLost ? ' (connection lost)' : ''}: $detail');
    // Every play/start, submit and connection failure the player is actually
    // shown funnels through here — one `error` report, debounced in TifoEvents.
    unawaited(TifoEvents.blocked(reason: TifoBlockReason.error, surface: TifoSurface.building));
    final l10n = AppLocalizations.of(ctx);
    unawaited(
      showTifoMessageDialog<void>(
        ctx,
        card: TifoMessageCard(
          showIllustration: true,
          title: connectionLost ? l10n.tifoConnectionLostTitle : l10n.tifoSomethingWentWrongTitle,
          body: connectionLost ? l10n.tifoConnectionLostBody : l10n.tifoSomethingWentWrongBody,
          primaryAction: TifoMessageAction(
            label: l10n.tifoRetry,
            onPressed: () {
              Navigator.of(ctx).pop();
              onRetry?.call();
            },
          ),
          onClose: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }
}

class _CloseBtn extends StatelessWidget {
  const _CloseBtn({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.neutralContainerDefault,
    shape: CircleBorder(side: BorderSide(color: context.colors.neutralContainerDefault)),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(
          Icons.close_rounded,
          size: 18,
          color: context.colors.neutralOnContainer,
        ),
      ),
    ),
  );
}
