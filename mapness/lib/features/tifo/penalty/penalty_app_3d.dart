import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:mapness/features/tifo/data/tifo_debug_goalkeeper_difficulty.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart' show tifoKeeperColorRgb, tifoStrikerColorRgb;
import 'package:mapness/features/tifo/penalty/penalty_hud_panel.dart';
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Unity-backed drop-in replacement for the Flame [PenaltyApp]: identical
/// constructor, identical host contract (onReady/arm gate, single onComplete
/// with the backend-shaped kick log, onConnectionLost, idle prompt, leave
/// confirmation), so `building_sheet.dart` swaps between the two by widget
/// name alone. Rendering and game rules live in Unity; everything the player
/// reads — dialogs and the score HUD — stays Flutter, drawn over the Unity
/// view. The HUD is fed from the per-kick events below, so Unity draws no text.
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
    this.onBackgrounded,
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

  /// See [PenaltyApp.onBackgrounded]: fires once when the app is backgrounded
  /// while the shootout is still live ("player left the pitch"), distinct
  /// from [onConnectionLost].
  final VoidCallback? onBackgrounded;
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
      onBackgrounded: onBackgrounded,
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
    required this.onBackgrounded,
    required this.missesAllowed,
    required this.scoreToBeat,
    required this.strikerColor,
    required this.keeperColor,
    required this.sessionTimeoutSeconds,
  });

  final ValueChanged<TifoShootoutOutcome>? onComplete;
  final void Function(VoidCallback arm)? onReady;
  final VoidCallback? onConnectionLost;
  final VoidCallback? onBackgrounded;
  final int missesAllowed;
  final int scoreToBeat;
  final String? strikerColor;
  final String? keeperColor;
  final int sessionTimeoutSeconds;

  @override
  State<_Penalty3DPage> createState() => _Penalty3DPageState();
}

class _Penalty3DPageState extends State<_Penalty3DPage> with WidgetsBindingObserver {
  static const String _bridge = 'PenaltyBridge';

  /// Same constants as the Flame page: warn this many seconds before the
  /// server's `liveLockTimeoutSeconds` void window, but never before the
  /// player has actually been idle for the floor.
  static const int _idleWarningBufferSeconds = 8;
  static const int _idleWarningFloorSeconds = 12;
  static const Duration _offlineGrace = Duration(seconds: 3);

  bool _armed = false;
  bool _completed = false;
  bool _backgroundReported = false;

  /// Live score for the Flutter HUD, mirrored from Unity's `kick`/`complete`
  /// events (same two counters the Flame game exposes as notifiers).
  final ValueNotifier<int> _goals = ValueNotifier<int>(0);
  final ValueNotifier<int> _misses = ValueNotifier<int>(0);

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

  /// True until Unity says "ready": the loading overlay covers the platform
  /// view (and with it the engine splash and the black first frames).
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(true);

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
        _loading.value = false;
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
        _onActivity();
      case 'kick':
        _onActivity();
        _updateScore(data);
      case 'complete':
        _updateScore(data);
        _onUnityComplete(data);
    }
  }

  /// `kick` and `complete` both carry the running totals; take them as sent so
  /// the HUD never disagrees with what Unity will report in the final outcome.
  void _updateScore(Map<String, dynamic> data) {
    final goals = (data['goals'] as num?)?.toInt();
    final misses = (data['misses'] as num?)?.toInt();
    if (goals != null) {
      _goals.value = goals;
    }
    if (misses != null) {
      _misses.value = misses;
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
    WidgetsBinding.instance.addObserver(this);
    _readyTimer = Timer.periodic(_readyRetryInterval, (timer) {
      if (_gotReady || !mounted || _readyRetries >= _readyRetryLimit) {
        timer.cancel();
        if (!_gotReady && mounted) {
          debugPrint('[Penalty3D] no "ready" from Unity after $_readyRetries resets');
          _loading.value = false; // show whatever Unity has, and the exit button
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

  // ---- Backgrounded (mirrors PenaltyGamePage) ----------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // `paused` (not `inactive`): iOS reports `inactive` for a notification
    // shade pull or a control-centre swipe, which is not leaving the game.
    if (state != AppLifecycleState.paused || _backgroundReported || _completed) {
      return;
    }
    _backgroundReported = true;
    widget.onBackgrounded?.call();
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
    WidgetsBinding.instance.removeObserver(this);
    _readyTimer?.cancel();
    _idleCheckTimer?.cancel();
    _offlineTimer?.cancel();
    unawaited(_connectivitySub?.cancel());
    _goals.dispose();
    _misses.dispose();
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
    _loading.dispose();
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
          // Same chrome layout as the Flame page: exit control on its own row
          // above the HUD card so the two never overlap. Kept static (no blur,
          // no animation) — overlays over the Unity platform view are where
          // Impeller is most fragile on low-memory devices.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _ExitButton(onTap: _confirmLeave),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: PenaltyHudPanel(
                      goals: _goals,
                      misses: _misses,
                      missesAllowed: widget.missesAllowed,
                      scoreToBeat: widget.scoreToBeat,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading screen until Unity reports "ready", ABOVE the HUD and the
          // exit button so the score card doesn't sit on the trophy; it also
          // hides the engine splash and the black frames before the first
          // render. Released as well when the ready wait gives up, so the
          // player is never locked behind it.
          Positioned.fill(child: _LoadingOverlay(loading: _loading)),
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

/// Full-screen loading card shown over the Unity view until "ready": the
/// champions-ribbon trophy on its navy with a few confetti flecks, the entry
/// screen's caption and title, and a spinner. Fades out and removes itself
/// once loading is over, so nothing stays layered over the platform view
/// during play.
class _LoadingOverlay extends StatefulWidget {
  const _LoadingOverlay({required this.loading});

  final ValueListenable<bool> loading;

  @override
  State<_LoadingOverlay> createState() => _LoadingOverlayState();
}

/// One static confetti fleck, positioned as a fraction of the screen.
class _Fleck extends StatelessWidget {
  const _Fleck({required this.left, required this.top, required this.size, required this.angle, required this.color});

  final double left, top, size, angle;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: Align(
      alignment: Alignment(left * 2 - 1, top * 2 - 1),
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: size,
          height: size * 0.62,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
      ),
    ),
  );
}

class _LoadingOverlayState extends State<_LoadingOverlay> {
  static const Duration _fade = Duration(milliseconds: 350);
  static const Color _caption = Color(0xFF5A9B8E);
  static const Color _title = Color(0xFFE8F5F3);
  static const Color _accent = Color(0xFF79DCD0);

  bool _gone = false;

  @override
  void initState() {
    super.initState();
    widget.loading.addListener(_onLoadingChanged);
  }

  @override
  void dispose() {
    widget.loading.removeListener(_onLoadingChanged);
    super.dispose();
  }

  void _onLoadingChanged() {
    if (!widget.loading.value) {
      setState(() {});
      Future<void>.delayed(_fade, () {
        if (mounted) {
          setState(() => _gone = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gone) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    return IgnorePointer(
      ignoring: !widget.loading.value,
      child: AnimatedOpacity(
        opacity: widget.loading.value ? 1 : 0,
        duration: _fade,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DecoratedBox(
            // Same navy as the champions ribbon, with a few of its teal and
            // mint flecks; the trophy is the ribbon's own artwork.
            decoration: const BoxDecoration(color: Color(0xFF141A2E)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _Fleck(left: 0.08, top: 0.18, size: 26, angle: -0.35, color: Color(0xFF45EBA5)),
                const _Fleck(left: 0.82, top: 0.14, size: 18, angle: 0.5, color: Color(0xFF21ABA5)),
                const _Fleck(left: 0.16, top: 0.72, size: 22, angle: 0.8, color: Color(0xFF21ABA5)),
                const _Fleck(left: 0.78, top: 0.66, size: 30, angle: -0.6, color: Color(0xFF1D566E)),
                const _Fleck(left: 0.62, top: 0.26, size: 12, angle: 0.2, color: Color(0xFFE8F5EE)),
                const _Fleck(left: 0.30, top: 0.60, size: 10, angle: -1.1, color: Color(0xFF45EBA5)),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 4),
                      Image.asset(
                        'packages/mapness/assets/tifo/images/champion_trophy.webp',
                        height: 168,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (_, __, ___) => const SizedBox(height: 168),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.tifoPenaltyChallenge.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.8,
                          color: _caption,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'PENALTY KICK',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          package: 'mapness',
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          letterSpacing: 0.6,
                          color: _title,
                        ),
                      ),
                      const Spacer(flex: 5),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: _accent),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
