import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

/// Unity-backed drop-in replacement for the Flame [PenaltyApp]: identical
/// constructor, identical host contract (onReady/arm gate, single onComplete
/// with the backend-shaped kick log), so `building_sheet.dart` can swap
/// between the two by widget name alone.
///
/// Spike scope: missesAllowed and the ready/arm/complete protocol are wired;
/// scoreToBeat/colors/timeout/connectivity are accepted but not yet forwarded
/// to Unity (the Flame game stays the reference implementation for those).
///
/// Message protocol (JSON strings over flutter_embed_unity):
///   Unity -> Flutter: {"event":"ready"}
///                     {"event":"complete","goals":G,"misses":M,
///                      "events":[{"kick":1,"result":"goal"|"miss"},...]}
///   Flutter -> Unity: sendToUnity("PenaltyBridge","Configure",<json>)
///                     sendToUnity("PenaltyBridge","Arm","")
class PenaltyApp3D extends StatefulWidget {
  const PenaltyApp3D({
    super.key,
    this.onComplete,
    this.onReady,
    this.onConnectionLost,
    this.missesAllowed = 3,
    this.scoreToBeat = 0,
    this.strikerColor,
    this.keeperColor,
    this.showColliderDebug = false,
    this.sessionTimeoutSeconds = 30,
    this.locale,
    this.goalkeeperDifficulty = const TifoGoalkeeperDifficulty(),
  });

  final ValueChanged<TifoShootoutOutcome>? onComplete;
  final void Function(VoidCallback arm)? onReady;
  final VoidCallback? onConnectionLost;
  final int missesAllowed;
  final int scoreToBeat;
  final String? strikerColor;
  final String? keeperColor;
  final bool showColliderDebug;
  final int sessionTimeoutSeconds;
  final Locale? locale;
  final TifoGoalkeeperDifficulty goalkeeperDifficulty;

  @override
  State<PenaltyApp3D> createState() => _PenaltyApp3DState();
}

class _PenaltyApp3DState extends State<PenaltyApp3D> {
  bool _completed = false;

  void _onMessageFromUnity(String message) {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(message) as Map<String, dynamic>;
    } catch (_) {
      debugPrint('[Penalty3D] unparseable message from Unity: $message');
      return;
    }
    switch (data['event']) {
      case 'ready':
        sendToUnity('PenaltyBridge', 'Configure', jsonEncode({'missesAllowed': widget.missesAllowed}));
        final onReady = widget.onReady;
        if (onReady != null) {
          // Same gate as the Flame game: the host opens /play/start between
          // "ready" and arm(), so the session clock never covers loading.
          onReady(() => sendToUnity('PenaltyBridge', 'Arm', ''));
        } else {
          sendToUnity('PenaltyBridge', 'Arm', '');
        }
      case 'complete':
        if (_completed) {
          return; // the contract promises exactly one completion
        }
        _completed = true;
        final events = <TifoKickEvent>[];
        for (final e in (data['events'] as List? ?? const [])) {
          if (e is Map) {
            events.add(
              TifoKickEvent(
                index: ((e['kick'] as num?)?.toInt() ?? events.length + 1) - 1,
                scored: e['result'] == 'goal',
                atMs: 0,
              ),
            );
          }
        }
        widget.onComplete?.call(
          TifoShootoutOutcome(
            goals: (data['goals'] as num?)?.toInt() ?? 0,
            misses: (data['misses'] as num?)?.toInt() ?? 0,
            events: events,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: EmbedUnity(onMessageFromUnity: _onMessageFromUnity),
  );
}
