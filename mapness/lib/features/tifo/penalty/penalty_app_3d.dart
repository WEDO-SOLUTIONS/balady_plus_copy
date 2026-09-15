import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:mapness/features/tifo/data/tifo_debug_goalkeeper_difficulty.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart' show tifoKeeperColorRgb, tifoStrikerColorRgb;
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Unity-backed drop-in replacement for the Flame [PenaltyApp]: identical
/// constructor, identical host contract (onReady/arm gate, single onComplete
/// with the backend-shaped kick log, onConnectionLost, idle prompt, leave
/// confirmation), so `building_sheet.dart` swaps between the two by widget
/// name alone. Rendering and game rules live in Unity; everything the player
/// reads — dialogs, later the HUD — stays Flutter, drawn over the Unity view.
///
/// Message protocol (JSON strings over flutter_embed_unity):
///   Unity -> Flutter: {"event":"ready"}
///                     {"event":"aim"}
///                     {"event":"kick","kick":N,"result":"goal"|"miss","saved":bool,"goals":G,"misses":M}
///                     {"event":"complete","goals":G,"misses":M,"events":[{"kick":1,"result":"goal"|"miss"},...]}
///   Flutter -> Unity: sendToUnity("PenaltyBridge","Configure",<json>)
///                     sendToUnity("PenaltyBridge","Arm","")
///                     sendToUnity("PenaltyBridge","Forfeit","")   — pads misses, completes
///                     sendToUnity("PenaltyBridge","Leave","")     — disposed without a result
class PenaltyApp3D extends StatelessWidget {
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

  /// Accepted for constructor parity with [PenaltyApp]; the 3D keeper is not
  /// tunable from the debug panel yet.
  final TifoGoalkeeperDifficulty goalkeeperDifficulty;

  /// Mirrors [PenaltyApp] so the dialogs render the app's fonts inside this
  /// isolated [MaterialApp].
  String get _fontFamily =>
      locale?.languageCode == 'ar' ? 'packages/balady_design_system/IBMPlexSansArabic' : 'packages/balady_uikit/Golos';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Penalty 3D',
    theme: ThemeData(brightness: Brightness.dark, useMaterial3: true, fontFamily: _fontFamily),
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: _Penalty3DPage(
      onComplete: onComplete,
      onReady: onReady,
      onConnectionLost: onConnectionLost,
      missesAllowed: missesAllowed,
      scoreToBeat: scoreToBeat,
      strikerColor: strikerColor,
      keeperColor: keeperColor,
      sessionTimeoutSeconds: sessionTimeoutSeconds,
    ),
  );
}

class _Penalty3DPage extends StatefulWidget {
  const _Penalty3DPage({
    required this.onComplete,
    required this.onReady,
    required this.onConnectionLost,
    required this.missesAllowed,
    required this.scoreToBeat,
    required this.strikerColor,
    required this.keeperColor,
    required this.sessionTimeoutSeconds,
  });

  final ValueChanged<TifoShootoutOutcome>? onComplete;
  final void Function(VoidCallback arm)? onReady;
  final VoidCallback? onConnectionLost;
  final int missesAllowed;
  final int scoreToBeat;
  final String? strikerColor;
  final String? keeperColor;
  final int sessionTimeoutSeconds;

  @override
  State<_Penalty3DPage> createState() => _Penalty3DPageState();
}

class _Penalty3DPageState extends State<_Penalty3DPage> {
  static const String _bridge = 'PenaltyBridge';

  /// Same constants as the Flame page: warn this many seconds before the
  /// server's `liveLockTimeoutSeconds` void window, but never before the
  /// player has actually been idle for the floor.
  static const int _idleWarningBufferSeconds = 8;
  static const int _idleWarningFloorSeconds = 12;
  static const Duration _offlineGrace = Duration(seconds: 3);

  bool _armed = false;
  bool _completed = false;

  /// Unity stays resident between matches, and the `Leave` we send on dispose
  /// can be dropped when the previous view is already torn down — leaving a
  /// stale, still-armed scene that never says "ready" for the new view. So a
  /// new view waits for "ready" only this long, then asks Unity to reset
  /// (reload, or just repeat "ready" if the scene is already fresh), and keeps
  /// asking a few times: a cold boot takes ~3–4 s and drops early messages.
  static const Duration _readyRetryInterval = Duration(milliseconds: 1500);
  static const int _readyRetryLimit = 6;
  bool _gotReady = false;
  int _readyRetries = 0;
  Timer? _readyTimer;

  Timer? _idleCheckTimer;
  DateTime? _lastActivityAt;
  bool _idlePromptOpen = false;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _offlineTimer;
  bool _connectionLostReported = false;

  // ---- Unity -> Flutter -------------------------------------------------

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
        if (_gotReady) {
          return; // a reset racing a cold boot can repeat it — configure once
        }
        _gotReady = true;
        _readyTimer?.cancel();
        _configureUnity();
        final onReady = widget.onReady;
        if (onReady != null) {
          // Same gate as the Flame game: the host opens /play/start between
          // "ready" and arm(), so the session clock never covers loading.
          onReady(_arm);
        } else {
          _arm();
        }
      case 'aim':
      case 'kick':
        _onActivity();
      case 'complete':
        _onUnityComplete(data);
    }
  }

  void _configureUnity() {
    sendToUnity(
      _bridge,
      'Configure',
      jsonEncode({
        'missesAllowed': widget.missesAllowed,
        'scoreToBeat': widget.scoreToBeat,
        'strikerColor': _hex(_bucketRgb(widget.strikerColor, tifoStrikerColorRgb)),
        'keeperColor': _hex(_bucketRgb(widget.keeperColor, tifoKeeperColorRgb)),
      }),
    );
  }

  static int? _bucketRgb(String? bucket, int? Function(String) table) => bucket == null ? null : table(bucket);

  static String? _hex(int? rgb) => rgb == null ? null : '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';

  void _arm() {
    if (!mounted || _armed || _completed) {
      return;
    }
    _armed = true;
    sendToUnity(_bridge, 'Arm', '');
    // Armed = the server session is open and the clock is running, which is
    // exactly the window where idling voids it and going offline loses it.
    _armIdleWatch();
    _watchConnectivity();
  }

  void _onUnityComplete(Map<String, dynamic> data) {
    if (_completed) {
      return; // the contract promises exactly one completion
    }
    _completed = true;
    _idleCheckTimer?.cancel();
    _offlineTimer?.cancel();
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

  // ---- Flutter -> Unity -------------------------------------------------

  @override
  void initState() {
    super.initState();
    _readyTimer = Timer.periodic(_readyRetryInterval, (timer) {
      if (_gotReady || !mounted || _readyRetries >= _readyRetryLimit) {
        timer.cancel();
        if (!_gotReady && mounted) {
          debugPrint('[Penalty3D] no "ready" from Unity after $_readyRetries resets');
        }
        return;
      }
      _readyRetries++;
      debugPrint('[Penalty3D] no "ready" yet — asking Unity to reset (#$_readyRetries)');
      try {
        sendToUnity(_bridge, 'Reset', '');
      } catch (e) {
        debugPrint('[Penalty3D] Reset not delivered: $e');
      }
    });
  }

  void _forfeit() {
    if (_completed) {
      return;
    }
    sendToUnity(_bridge, 'Forfeit', '');
  }

  // ---- Idle watch (mirrors PenaltyGamePage) ------------------------------

  void _onActivity() => _lastActivityAt = DateTime.now();

  void _armIdleWatch() {
    _lastActivityAt = DateTime.now();
    _idleCheckTimer?.cancel();
    _idleCheckTimer = Timer.periodic(const Duration(seconds: 1), (_) => _checkIdle());
  }

  void _checkIdle() {
    final lastActivityAt = _lastActivityAt;
    if (_completed || _idlePromptOpen || lastActivityAt == null || !mounted) {
      return;
    }
    final idleSeconds = DateTime.now().difference(lastActivityAt).inSeconds;
    final warnAfter = math.max(widget.sessionTimeoutSeconds - _idleWarningBufferSeconds, _idleWarningFloorSeconds);
    if (idleSeconds >= warnAfter) {
      unawaited(_showStillPlayingPrompt());
    }
  }

  Future<void> _showStillPlayingPrompt() async {
    _idlePromptOpen = true;
    final l10n = AppLocalizations.of(context);
    final exit = await showTifoMessageDialog<bool>(
      context,
      barrierDismissible: false,
      card: TifoMessageCard(
        title: l10n.tifoStillPlayingTitle,
        body: l10n.tifoStillPlayingBody,
        secondaryAction: TifoMessageAction(label: l10n.tifoExit, onPressed: () => Navigator.of(context).pop(true)),
        onClose: () => Navigator.of(context).pop(false),
        primaryAction: TifoMessageAction(label: l10n.tifoContinue, onPressed: () => Navigator.of(context).pop(false)),
      ),
    );
    _idlePromptOpen = false;
    if (!mounted) {
      return;
    }
    if (exit ?? false) {
      _forfeit();
    } else {
      _onActivity();
    }
  }

  // ---- Connectivity (mirrors PenaltyGamePage) ----------------------------

  void _watchConnectivity() {
    _connectivitySub?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    // An empty list means the platform didn't say — treat as connected rather
    // than killing the run on missing information. A momentary `none` during
    // a Wi-Fi -> cellular handover must not abandon a paid run either.
    final offline = results.isNotEmpty && results.every((r) => r == ConnectivityResult.none);
    if (!offline) {
      _offlineTimer?.cancel();
      _offlineTimer = null;
      return;
    }
    if (_offlineTimer != null || _connectionLostReported) {
      return;
    }
    _offlineTimer = Timer(_offlineGrace, () {
      _offlineTimer = null;
      if (!mounted || _connectionLostReported || _completed) {
        return;
      }
      _connectionLostReported = true;
      _idleCheckTimer?.cancel();
      widget.onConnectionLost?.call();
    });
  }

  // ---- Leave (exit button / back) ----------------------------------------

  Future<void> _confirmLeave() async {
    if (_completed) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final leave = await showTifoMessageDialog<bool>(
      context,
      card: TifoMessageCard(
        title: l10n.tifoLeaveChallengeTitle,
        body: l10n.tifoLeaveChallengeBody,
        secondaryAction: TifoMessageAction(label: l10n.tifoLeave, onPressed: () => Navigator.of(context).pop(true)),
        onClose: () => Navigator.of(context).pop(false),
        primaryAction: TifoMessageAction(label: l10n.tifoStay, onPressed: () => Navigator.of(context).pop(false)),
      ),
    );
    if (!mounted) {
      return;
    }
    if (leave ?? false) {
      _forfeit();
    } else {
      _onActivity();
    }
  }

  @override
  void dispose() {
    _readyTimer?.cancel();
    _idleCheckTimer?.cancel();
    _offlineTimer?.cancel();
    unawaited(_connectivitySub?.cancel());
    if (!_completed) {
      // Closed without a result (host popped the route on connection loss,
      // or the widget went away): tell Unity so its next resume starts a
      // fresh scene instead of showing this half-played one.
      try {
        sendToUnity(_bridge, 'Leave', '');
      } catch (e) {
        debugPrint('[Penalty3D] Leave not delivered: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) {
        unawaited(_confirmLeave());
      }
    },
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: EmbedUnity(onMessageFromUnity: _onMessageFromUnity)),
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(child: _ExitButton(onTap: _confirmLeave)),
          ),
        ],
      ),
    ),
  );
}

/// Top-right "X" to bail out mid-game — same look and semantics as the Flame
/// page's exit: confirm, then forfeit (remaining attempts padded as misses).
class _ExitButton extends StatelessWidget {
  const _ExitButton({required this.onTap});

  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xCC0A1424),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0x2934D399)),
    ),
    child: InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => unawaited(onTap()),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.close, color: Colors.white, size: 22),
      ),
    ),
  );
}
