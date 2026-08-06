import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_debug_collider_overlay.dart';
import 'package:mapness/features/tifo/data/tifo_debug_color_override.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart';
import 'package:mapness/features/tifo/penalty/penalty_result_screen.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_poller.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Opens the capture sheet for [building] on the root navigator, so it floats
/// above the map regardless of who triggered it (a polygon tap from the map
/// layer, which isn't a widget). Rebuilt to the Figma light "building details"
/// sheet (BRD US-08), with the three status states (available / live /
/// cooldown).
Future<void> showTifoBuildingSheet(BuildContext context, TifoBuilding building) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: TifoColors.surface,
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
    final session = ref.watch(tifoSessionProvider);
    final ownerClub = session.clubById(_building.ownerClubSlug);
    final ownerColor = ownerClub == null ? TifoColors.neutralFill : Color(ownerClub.colorArgb);
    final isClaim = _building.isNeutral;

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
                decoration: BoxDecoration(color: TifoColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 32),
                const Expanded(
                  child: Center(
                    child: Text('Claim the building', style: TifoText.h2, textAlign: TextAlign.center),
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
                        const Text('Unclaimed', style: TifoText.captionMedium),
                        const SizedBox(height: 8),
                        Text(_building.displayName, style: TifoText.bodyLSemi),
                        const SizedBox(height: 2),
                        const Text("This building hasn't been claimed yet.", style: TifoText.captionRegular),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Owner', style: TifoText.captionMedium),
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
                  const Text('Current score to beat', style: TifoText.captionMedium),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isClaim ? 0 : _building.scoreToBeat}',
                        style: TifoText.h2.copyWith(color: TifoColors.accentSoft),
                      ),
                      const SizedBox(width: 6),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Text('goals', style: TifoText.captionRegular),
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
                  Text('${_building.contested7d}', style: TifoText.h3),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This building has been played ${_building.contested7d} '
                      'time${_building.contested7d == 1 ? '' : 's'} in the last 7 days.',
                      style: TifoText.captionRegular,
                    ),
                  ),
                ],
              ),
            ),

            if (_building.isAvailable) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: TifoColors.accentContainer,
                  borderRadius: BorderRadius.circular(TifoRadii.ml),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 18, color: TifoColors.accentSoft),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isClaim
                            ? 'Be the first to claim it for your team.'
                            : 'Win the challenge and dominate with your team.',
                        style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft),
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
            if (_building.isAvailable)
              TifoPrimaryButton(
                label: isClaim ? 'Claim building' : 'Challenge',
                leadingEmoji: '⚽',
                busy: _isBusy,
                onPressed: _isBusy ? null : _onPlayPressed,
              )
            else
              _disabledBar(
                _building.status == 'live'
                    ? 'Hold on… this building is currently being played for.'
                    : 'Cooling down — try again shortly.',
              ),

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
                  onPressed: (_building.isAvailable && !_isBusy) ? _mockCapture : null,
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
      color: TifoColors.surface,
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
      // "Challenge / mock capture is broken".
      final step = ref.read(tifoSessionProvider).nextStep;
      setState(() {
        _isBusy = false;
        _error = 'Not play-ready — unmet step: ${step.name}';
      });
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
              Future<void>.delayed(const Duration(milliseconds: 250), () {
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
      _showResult(e is TifoApiException ? '${e.statusCode}: ${e.message}' : e.toString(), win: false);
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
        unawaited(showTifoPenaltyResult(ctx, result, scoreToBeat: _building.scoreToBeat));
      }
    } catch (e) {
      final message = e is TifoApiException ? e.message : e.toString();
      // The backend voids a session that outlived `expiresAt` and keeps the
      // token (FR-16). Say so plainly — "Submit failed" reads like a bug and
      // sends testers hunting for one.
      final expired = message.toLowerCase().contains('expired');
      logger.log('[tifo] submit failed${expired ? ' (session expired)' : ''}: $message');
      _showResult(
        expired
            ? 'Session expired — a run must finish within '
                  '${container.read(tifoSessionProvider).config.liveLockTimeoutSeconds}s of starting. '
                  'The token was spent; try again.'
            : 'Submit failed: $message',
        win: false,
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
    final ready = await TifoJourney(ref).ensurePlayReady(context);
    if (!mounted) {
      return;
    }
    if (!ready) {
      // Surface WHY: the gate walk bails silently (cancelled login, skipped
      // tutorial, "Maybe Later"), and a button that just goes quiet reads as
      // "Challenge / mock capture is broken".
      final step = ref.read(tifoSessionProvider).nextStep;
      setState(() {
        _isBusy = false;
        _error = 'Not play-ready — unmet step: ${step.name}';
      });
      return;
    }

    final resultCtx = rootNavigatorKey.currentContext;
    if (resultCtx != null) {
      unawaited(precacheTifoResultImages(resultCtx));
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

  /// Win/Loss feedback via a dialog on the root navigator — the map/landing
  /// route has no Scaffold, so a ScaffoldMessenger snackbar asserts. Interim
  /// until the dedicated Win/Loss result screen (US-14) is built.
  void _showResult(String message, {required bool win}) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      return;
    }
    unawaited(
      showDialog<void>(
        context: ctx,
        builder: (dctx) => AlertDialog(
          backgroundColor: TifoColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TifoRadii.l)),
          content: Row(
            children: [
              Text(win ? '🏆' : '⚽', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: TifoText.bodyL)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dctx).pop(),
              child: Text('Continue', style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent)),
            ),
          ],
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
    color: TifoColors.surface,
    shape: const CircleBorder(side: BorderSide(color: TifoColors.border)),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: const SizedBox(
        width: 32,
        height: 32,
        child: Icon(Icons.close_rounded, size: 18, color: TifoColors.textSoft),
      ),
    ),
  );
}
