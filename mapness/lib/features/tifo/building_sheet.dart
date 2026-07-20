import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/penalty_game.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';

/// Opens the capture sheet for [building] on the root navigator, so it floats
/// above the map regardless of who triggered it (a polygon tap from the map
/// layer, which isn't a widget).
Future<void> showTifoBuildingSheet(BuildContext context, TifoBuilding building) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: const Color(0xFF10241C),
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

  TifoBuilding get _building => widget.building;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(tifoSessionProvider);
    final ownerClub = session.clubById(_building.ownerClubSlug);
    final ownerColor = ownerClub == null ? const Color(0xFFB9B29C) : Color(ownerClub.colorArgb);
    final isClaim = _building.isNeutral;
    final cost = isClaim ? session.config.claimCost : session.config.challengeCost;
    final canPlay = _building.isAvailable && !_isBusy;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(
              _building.displayName,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text('ID: ${_building.id}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 16),

            // Ownership
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: ownerColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  ownerClub?.name ?? 'No team owns this building yet',
                  style: TextStyle(color: ownerColor, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Score to beat + contested + status
            _InfoRow(label: 'Score to beat', value: isClaim ? '0 (unclaimed)' : '${_building.scoreToBeat}'),
            _InfoRow(label: 'Contested (7d)', value: '${_building.contested7d}'),
            _InfoRow(label: 'Status', value: _statusLabel(_building.status)),
            _InfoRow(label: isClaim ? 'Claim cost' : 'Challenge cost', value: '$cost token${cost == 1 ? '' : 's'}'),

            if (!_building.isAvailable) ...[
              const SizedBox(height: 10),
              Text(
                _building.status == 'live'
                    ? 'Someone is playing this building right now.'
                    : 'This building is cooling down. Try again shortly.',
                style: const TextStyle(color: Color(0xFFF2C94C), fontSize: 12),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Color(0xFFE5484D), fontSize: 13)),
            ],
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: canPlay ? const Color(0xFF1B8354) : Colors.white12,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: canPlay ? _onPlayPressed : null,
                icon: _isBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sports_soccer_rounded),
                label: Text(_isBusy ? 'Starting…' : (isClaim ? 'Claim building' : 'Challenge')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
    'available' => 'Available',
    'cooldown' => 'Cooldown',
    'live' => 'Live',
    _ => status,
  };

  /// Runs the BRD play-gate (login → tutorial → team) before starting. If the
  /// player isn't ready and doesn't complete the gate, we stop.
  Future<void> _onPlayPressed() async {
    setState(() {
      _isBusy = true;
      _error = null;
    });

    final ready = await TifoJourney(ref).ensurePlayReady(context);
    if (!mounted) {
      return;
    }
    if (!ready) {
      setState(() => _isBusy = false);
      return;
    }
    await _startAndPlay();
  }

  Future<void> _startAndPlay() async {
    final api = ref.read(tifoApiProvider);
    final TifoPlaySession playSession;
    try {
      playSession = await api.startPlay(_building.id);
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isBusy = false;
        _error = e is TifoApiException ? '${e.statusCode}: ${e.message}' : e.toString();
      });
      return;
    }
    // Token was just spent; refresh the balance shown elsewhere.
    unawaited(ref.read(tifoSessionProvider.notifier).refreshProfile());

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(); // close the sheet
    _runShootout(playSession);
  }

  void _runShootout(TifoPlaySession playSession) {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) {
      return;
    }
    final missesAllowed = ref.read(tifoSessionProvider).config.missesAllowed;
    var handled = false;
    unawaited(
      navigator.push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => PenaltyApp(
            missesAllowed: missesAllowed,
            onComplete: (outcome) {
              if (handled) {
                return;
              }
              handled = true;
              Future<void>.delayed(const Duration(milliseconds: 700), () {
                rootNavigatorKey.currentState?.pop();
                unawaited(_submit(playSession: playSession, outcome: outcome));
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submit({required TifoPlaySession playSession, required TifoShootoutOutcome outcome}) async {
    final api = ref.read(tifoApiProvider);
    final messenger = _messenger();
    try {
      final result = await api.submitPlay(
        buildingId: _building.id,
        sessionId: playSession.sessionId,
        score: outcome.goals,
        events: outcome.events.map((e) => e.toJson()).toList(),
      );
      // Reflect capture immediately using the player's own club; the next
      // viewport refresh reconciles from the server regardless.
      if (result.isWin) {
        final myClub = ref.read(tifoSessionProvider).myClub;
        if (myClub != null) {
          ref
              .read(tifoBuildingsProvider.notifier)
              .applyOwnership(
                buildingId: _building.id,
                clubSlug: myClub.id,
                savedScore: result.yourScore,
              );
        }
      }
      unawaited(ref.read(tifoSessionProvider.notifier).refreshProfile());
      messenger?.showSnackBar(SnackBar(content: Text(_outcomeMessage(result))));
    } catch (e) {
      messenger?.showSnackBar(
        SnackBar(content: Text('Submit failed: ${e is TifoApiException ? e.message : e}')),
      );
    }
  }

  ScaffoldMessengerState? _messenger() {
    final ctx = rootNavigatorKey.currentContext;
    return ctx == null ? null : ScaffoldMessenger.maybeOf(ctx);
  }

  // BRD: result is Win/Loss, no numeric scoreline.
  String _outcomeMessage(TifoPlayResult r) => switch (r.outcome) {
    TifoOutcome.claimed => 'You claimed this building! 🏆',
    TifoOutcome.taken => 'You took it from the rival! 🏆',
    TifoOutcome.failed => 'Not this time — the building holds.',
    TifoOutcome.voided => 'Session voided.',
    TifoOutcome.unknown => 'Challenge complete.',
  };
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
