import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
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

  /// Captured before the sheet is popped so the post-game submit (which runs
  /// after this State is disposed) can still read providers.
  ProviderContainer? _container;

  TifoBuilding get _building => widget.building;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(tifoSessionProvider);
    final ownerClub = session.clubById(_building.ownerClubSlug);
    final ownerColor = ownerClub == null ? TifoColors.neutralFill : Color(ownerClub.colorArgb);
    final isClaim = _building.isNeutral;
    // BRD US-08: browsing is always allowed, but a player who hasn't cleared
    // the play-gate yet (e.g. "Maybe Later" on team select) can't start a
    // challenge — show that up front instead of letting them tap Challenge
    // and hit a gate failure.
    final canChallenge = session.isPlayReady;
    // The server 409s `play/start` for a building the player's own club
    // already holds — used to only surface after the game had already
    // opened and closed again. Block the CTA up front instead.
    final isOwnBuilding = _building.ownerClubSlug != null && _building.ownerClubSlug == session.myClub?.id;

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
                        Text(l10n.tifoUnclaimed, style: TifoText.captionMedium),
                        const SizedBox(height: 8),
                        Text(
                          _building.displayName,
                          style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: 2),
                        Text(l10n.tifoNotClaimedYet, style: TifoText.captionRegular),
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
                            Expanded(child: Text(ownerClub?.name ?? _building.displayName, style: TifoText.bodyLSemi)),
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
                        '${isClaim ? 0 : _building.scoreToBeat}',
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
                    '${_building.contested7d}',
                    style: TifoText.h3.copyWith(color: context.colors.foregroundDefault),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.tifoContestedCount(_building.contested7d),
                      style: TifoText.captionRegular,
                    ),
                  ),
                ],
              ),
            ),

            if (_building.isAvailable && !isOwnBuilding) ...[
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

            // CTA by status.
            if (_building.isAvailable && canChallenge && !isOwnBuilding)
              TifoPrimaryButton(
                label: isClaim ? l10n.tifoClaimBuilding : l10n.tifoChallenge,
                leadingEmoji: '⚽',
                busy: _isBusy,
                onPressed: _isBusy ? null : _onPlayPressed,
              )
            else if (isOwnBuilding)
              _disabledBar(l10n.tifoOwnBuildingHint)
            else if (_building.isAvailable)
              _disabledBar(l10n.tifoNotPlayReady)
            else
              _disabledBar(_building.status == 'live' ? l10n.tifoBuildingLiveHint : l10n.tifoBuildingCooldownHint),

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
                  onPressed: (_building.isAvailable && !_isBusy && !isOwnBuilding) ? _mockCapture : null,
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
      color: TifoColors.neutralFill.withValues(alpha: 0.85),
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

    final ready = await TifoJourney(ref).ensurePlayReady(context);
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
    unawaited(
      navigator.push<void>(
        MaterialPageRoute<void>(
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
            onReady: (arm) => unawaited(
              _openSession(container).then((session) {
                if (session == null) {
                  return; // start failed — the game route is already gone
                }
                playSession = session;
                arm();
              }),
            ),
            onComplete: (outcome) {
              final session = playSession;
              if (handled || session == null) {
                return;
              }
              handled = true;
              container.read(tifoBuildingsPollerProvider.notifier).start();
              // Short beat so the last GOAL!/MISS! flash is readable, then
              // submit — kept tight because the clock is still running.
              Future<void>.delayed(const Duration(seconds: 2), () {
                rootNavigatorKey.currentState?.pop();
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
  Future<TifoPlaySession?> _openSession(ProviderContainer container) async {
    try {
      final session = await container.read(tifoApiProvider).startPlay(_building.id);
      // Token was just spent; refresh the balance shown elsewhere.
      unawaited(container.read(tifoSessionProvider.notifier).refreshProfile());
      return session;
    } catch (e) {
      rootNavigatorKey.currentState?.pop();
      _showResult(e is TifoApiException ? '${e.statusCode}: ${e.message}' : e.toString(), onRetry: _onPlayPressed);
      return null;
    }
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
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) {
        unawaited(
          showTifoPenaltyResult(
            ctx,
            result,
            winnerColorKey: tifoResultColorKeyFor(container.read(tifoSessionProvider).myClub?.id),
            // Building's owner BEFORE this attempt — `applyOwnership` above only
            // mutates `tifoBuildingsProvider`'s map, not this widget's own
            // `_building` field, so this still reads the pre-capture value.
            buildingOwnerColorKeyBeforePlay: tifoResultColorKeyFor(_building.ownerClubSlug),
          ),
        );
      }
    } catch (e) {
      final message = e is TifoApiException ? e.message : e.toString();
      // The backend voids a session that outlived `expiresAt` and keeps the
      // token (FR-16). Say so plainly — "Submit failed" reads like a bug and
      // sends testers hunting for one.
      final expired = message.toLowerCase().contains('expired');
      logger.log('[tifo] submit failed${expired ? ' (session expired)' : ''}: $message');
      _showResult('Submit failed: $message', connectionLost: expired, onRetry: _onPlayPressed);
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
    final ready = await TifoJourney(ref).ensurePlayReady(context);
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
  void _showResult(String message, {bool connectionLost = false, VoidCallback? onRetry}) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      return;
    }
    final l10n = AppLocalizations.of(ctx);
    unawaited(
      showTifoMessageDialog<void>(
        ctx,
        card: TifoMessageCard(
          showIllustration: true,
          title: connectionLost ? l10n.tifoConnectionLostTitle : l10n.tifoSomethingWentWrongTitle,
          body: connectionLost ? l10n.tifoConnectionLostBody : message,
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
