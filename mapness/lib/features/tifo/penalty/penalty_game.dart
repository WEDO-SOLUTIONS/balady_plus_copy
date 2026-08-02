import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audio_session/audio_session.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:just_audio_platform_interface/method_channel_just_audio.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class PenaltyApp extends StatelessWidget {
  const PenaltyApp({
    super.key,
    this.onComplete,
    this.onReady,
    this.missesAllowed = 3,
    this.scoreToBeat = 0,
  });

  /// Fires once the session ends. Carries goals, misses and the per-kick event
  /// log — the log must be forwarded to `/buildings/{id}/play`, since the
  /// backend recomputes the score from it (anti-cheat).
  final ValueChanged<TifoShootoutOutcome>? onComplete;

  /// Session ends after this many misses (from `/config`, default 3).
  final int missesAllowed;

  /// Saved score of the challenged building, shown in the HUD panel
  /// ("Score to beat", FD-50). 0 for an unclaimed building.
  final int scoreToBeat;

  /// Fired when the pitch is loaded and ready for the first kick, handing back
  /// the callback that unlocks input. The caller opens the server session in
  /// between, so its short expiry window doesn't cover asset loading.
  final void Function(VoidCallback arm)? onReady;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penalty 3D',
      theme: ThemeData.dark(useMaterial3: true),
      home: PenaltyGamePage(
        onComplete: onComplete,
        onReady: onReady,
        missesAllowed: missesAllowed,
        scoreToBeat: scoreToBeat,
      ),
    );
  }
}

enum _PenaltyView { perspective, topDown, miniGame, styles }

class PenaltyGamePage extends StatefulWidget {
  const PenaltyGamePage({
    super.key,
    this.onComplete,
    this.onReady,
    this.missesAllowed = 3,
    this.scoreToBeat = 0,
  });

  final ValueChanged<TifoShootoutOutcome>? onComplete;
  final void Function(VoidCallback arm)? onReady;
  final int missesAllowed;
  final int scoreToBeat;

  @override
  State<PenaltyGamePage> createState() => _PenaltyGamePageState();
}

class _PenaltyGamePageState extends State<PenaltyGamePage> {
  _PenaltyView _view = _PenaltyView.perspective;

  /// Created once so the HUD panel can listen to the same instance the
  /// GameWidget renders.
  late final PenaltyGame _perspectiveGame =
      PenaltyGame(
          onComplete: widget.onComplete,
          missesAllowed: widget.missesAllowed,
        )
        ..onReady = () {
          final onReady = widget.onReady;
          // Nobody waiting on the session (debug/standalone run) → play right away.
          if (onReady == null) {
            _perspectiveGame.arm();
          } else {
            onReady(_perspectiveGame.arm);
          }
        };

  // Crowd-ambience tracks — one is picked at random each time this page
  // opens, so repeat playthroughs don't always hear the same loop. Add more
  // file paths here as additional tracks become available; nothing else
  // needs to change.
  static const List<String> _ambienceTracks = [
    'packages/mapness/assets/tifo/audio/crowd_ambience_1.mp3',
  ];

  AudioPlayer? _ambiencePlayer;

  @override
  void initState() {
    super.initState();
    unawaited(_startAmbience());
  }

  Future<void> _startAmbience() async {
    final track = _ambienceTracks[math.Random().nextInt(_ambienceTracks.length)];
    final player = AudioPlayer();
    _ambiencePlayer = player;
    try {
      // Without this, the session stays on the OS default `soloAmbient`
      // category, which iOS silences whenever the ringer/mute switch is on —
      // the game would render fine but play no sound at all. `.music()`
      // picks the `playback` category (ignores the mute switch) and mirrors
      // what the radio feature configures for itself elsewhere in the app.
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      // just_audio_background is active app-wide (radio feature) and asserts
      // every AudioSource carries a MediaItem tag — setAsset() doesn't set
      // one, which throws and gets swallowed below as a silent "no sound".
      await player.setAudioSource(
        AudioSource.asset(
          track,
          tag: const MediaItem(id: 'tifo_ambience', title: 'Tifo ambience'),
        ),
      );
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(0.35);
      // The page may have been disposed while the asset was loading.
      if (!mounted) {
        await player.dispose();
        return;
      }
      await player.play();
      debugPrint('[tifo-audio] ambience playing: $track');
    } catch (e, st) {
      // Ambience is a nice-to-have — a missing/corrupt asset shouldn't take
      // the whole penalty game down with it. Still log it: this swallows the
      // one signal we'd otherwise have for diagnosing "no sound" reports.
      debugPrint('[tifo-audio] ambience failed: $e\n$st');
    }
  }

  @override
  void dispose() {
    unawaited(_ambiencePlayer?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_view) {
      case _PenaltyView.perspective:
        body = ClipRect(
          child: GameWidget<PenaltyGame>(
            key: const ValueKey('penalty-game'),
            game: _perspectiveGame,
          ),
        );
        break;
      case _PenaltyView.topDown:
        body = const TopDownPenaltyGameWidget();
        break;
      case _PenaltyView.miniGame:
        body = const MiniFootballGameWidget();
        break;
      case _PenaltyView.styles:
        body = const StylesGalleryWidget();
        break;
    }
    final showModeToolbar = _view != _PenaltyView.perspective;
    final content = Stack(
      children: [
        Positioned.fill(child: body),
        // Info panel per Figma 696:112029 (BRD V2 HUD, FD-48…50): misses
        // remaining / Scored / Score to beat over the live game.
        if (_view == _PenaltyView.perspective)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: _PenaltyHudPanel(game: _perspectiveGame, scoreToBeat: widget.scoreToBeat),
            ),
          ),
        if (showModeToolbar)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 76),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  type: MaterialType.transparency,
                  child: _PenaltyModeToolbar(
                    selected: _view,
                    compact: true,
                    onChanged: (view) => setState(() => _view = view),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    if (_view == _PenaltyView.topDown || _view == _PenaltyView.miniGame || _view == _PenaltyView.styles) {
      return content;
    }
    return Material(color: Colors.black, child: content);
  }
}

/// "Penalty challenge" info panel (Figma 696:112029): dark translucent card
/// with a gradient hairline on top; three columns — misses remaining (ball =
/// left, red cross = spent), Scored and Score to beat. Fields per BRD V2
/// FD-48…50 — no "Attempted"/"Missed" counters.
class _PenaltyHudPanel extends StatelessWidget {
  const _PenaltyHudPanel({required this.game, required this.scoreToBeat});

  final PenaltyGame game;
  final int scoreToBeat;

  static const Color _title = Color(0xFF4ADE80);
  static const Color _label = Color(0xFF86EFAC);
  static const Color _caption = Color(0xB386EFAC);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xCC0A1424),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x2934D399)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gradient hairline along the top edge (purple → green in the design).
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF22C55E)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: game.armedNotifier,
                builder: (_, armed, _) => Text(
                  armed ? 'Penalty challenge' : 'Preparing the pitch…',
                  style: const TextStyle(color: _title, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: game.missesNotifier,
                      builder: (_, misses, _) {
                        final remaining = (game.missesAllowed - misses).clamp(0, game.missesAllowed);
                        return _HudColumn(
                          label: 'misses remaining',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < remaining; i++)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: TifoBallIcon(size: 16),
                                ),
                              for (var i = 0; i < misses; i++)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Text('❌', style: TextStyle(fontSize: 14)),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: game.goalsNotifier,
                      builder: (_, goals, _) => _HudColumn(
                        label: 'Scored',
                        child: _HudScore(value: goals),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _HudColumn(
                      label: 'Score to beat',
                      child: _HudScore(value: scoreToBeat),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _HudColumn extends StatelessWidget {
  const _HudColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: const TextStyle(color: _PenaltyHudPanel._label, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      child,
    ],
  );
}

class _HudScore extends StatelessWidget {
  const _HudScore({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '$value',
        style: const TextStyle(
          color: _PenaltyHudPanel._title,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      const SizedBox(height: 2),
      const Text('goals', style: TextStyle(color: _PenaltyHudPanel._caption, fontSize: 11)),
    ],
  );
}

class _PenaltyModeToolbar extends StatelessWidget {
  const _PenaltyModeToolbar({
    required this.selected,
    required this.compact,
    required this.onChanged,
  });

  final _PenaltyView selected;
  final bool compact;
  final ValueChanged<_PenaltyView> onChanged;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: compact ? const Color(0x6607111F) : const Color(0xB0000000),
      border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 8 : 10,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (!compact)
            const Text(
              'Penalty 3D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          SegmentedButton<_PenaltyView>(
            key: const ValueKey('penalty-view-toggle'),
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFFEAF2FF);
                }
                return Colors.white.withValues(alpha: 0.1);
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF10243D);
                }
                return Colors.white;
              }),
              side: WidgetStateProperty.all(
                BorderSide(color: Colors.white.withValues(alpha: 0.22)),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            segments: const [
              ButtonSegment(
                value: _PenaltyView.perspective,
                label: Text('3D'),
              ),
              ButtonSegment(
                value: _PenaltyView.topDown,
                label: Text('Top'),
              ),
              ButtonSegment(
                value: _PenaltyView.miniGame,
                label: Text('Mini'),
              ),
              ButtonSegment(value: _PenaltyView.styles, label: Text('Styles')),
            ],
            selected: {selected},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    ),
  );
}

class TopDownPenaltyGameWidget extends StatelessWidget {
  const TopDownPenaltyGameWidget({super.key});

  @override
  Widget build(BuildContext context) => const ClipRect(
    child: GameWidget<TopDownPenaltyGame>.controlled(
      key: ValueKey('top-down-penalty-game'),
      gameFactory: TopDownPenaltyGame.new,
    ),
  );
}

enum _TopDownShotState { aiming, flying, goal, saved, missed }

class TopDownPenaltyGame extends FlameGame with TapCallbacks, DragCallbacks {
  static const double _pitchHalfWidth = 5.6;
  static const double _fieldBottomY = 14.2;
  static const double _worldTopY = -1.05;
  static const double _worldBottomY = 14.8;
  static const double _goalY = 0;
  static const double _goalHalfWidth = 2.62;
  static const double _ballStartY = 11;
  static const double _keeperY = 0.62;
  static const double _ballRadius = 0.19;

  final _random = math.Random(17);
  _TopDownShotState _state = _TopDownShotState.aiming;
  Vector2 _ball = Vector2(0, _ballStartY);
  Vector2 _velocity = Vector2.zero();
  Vector2 _aimTarget = Vector2(0, _goalY);
  Vector2? _dragStart;
  Vector2? _dragCurrent;
  ui.Image? _keeperIdleSprite;
  ui.Image? _keeperDiveSprite;
  ui.Image? _ballSprite;
  double _elapsed = 0;
  double _shotTime = 0;
  double _resultTime = 0;
  double _keeperX = 0;
  double _keeperTargetX = 0;
  double _diveDirection = 0;
  double _curve = 0;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      final sprites = await Future.wait([
        _loadPixelatedUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_idle.png', 64),
        _loadPixelatedUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_left.png', 52),
        _loadPixelatedUiImage('packages/mapness/assets/tifo/sprites/soccer_ball.png', 18),
      ]);
      _keeperIdleSprite = sprites[0];
      _keeperDiveSprite = sprites[1];
      _ballSprite = sprites[2];
    } catch (_) {
      _keeperIdleSprite = null;
      _keeperDiveSprite = null;
      _ballSprite = null;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_state == _TopDownShotState.aiming) {
      _shootAt(event.canvasPosition, 0.72);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_state != _TopDownShotState.aiming) {
      return;
    }
    _dragStart = event.canvasPosition.clone();
    _dragCurrent = event.canvasPosition.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_state != _TopDownShotState.aiming) {
      return;
    }
    _dragCurrent = event.canvasEndPosition.clone();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_state != _TopDownShotState.aiming) {
      return;
    }
    final start = _dragStart;
    final end = _dragCurrent ?? start;
    if (start != null && end != null) {
      final dragLength = (end - start).length;
      final power = (0.48 + dragLength / 420).clamp(0.58, 1.0).toDouble();
      _shootAt(end, power);
    }
    _dragStart = null;
    _dragCurrent = null;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _dragStart = null;
    _dragCurrent = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_state == _TopDownShotState.aiming) {
      _keeperX = math.sin(_elapsed * 1.25) * 1.38;
      return;
    }

    if (_state == _TopDownShotState.flying) {
      _shotTime += dt;
      _keeperX += (_keeperTargetX - _keeperX) * (1 - math.exp(-dt * 6.2));
      _velocity.x += _curve * dt;
      _ball.x += _velocity.x * dt;
      _ball.y += _velocity.y * dt;

      if (_ball.y <= _goalY) {
        _ball.y = _goalY;
        _resolveShot();
      } else if (_ball.x.abs() > _pitchHalfWidth + 1.2 || _ball.y > _fieldBottomY + 1.5) {
        _finish(_TopDownShotState.missed);
      }
      return;
    }

    _resultTime += dt;
    _keeperX += (_keeperTargetX - _keeperX) * (1 - math.exp(-dt * 4.1));
    _ball.x += _velocity.x * dt;
    _ball.y += _velocity.y * dt;
    _velocity.scale(math.pow(0.12, dt).toDouble());
    if (_resultTime > 1.55) {
      _resetRound();
    }
  }

  @override
  void render(Canvas canvas) {
    _drawTopDownScene(canvas);
    super.render(canvas);
  }

  void _shootAt(Vector2 canvasPoint, double power) {
    _aimTarget = _targetFromCanvas(canvasPoint);
    _state = _TopDownShotState.flying;
    _shotTime = 0;
    _resultTime = 0;

    final flightTime = 0.7 - power * 0.18;
    final target = _aimTarget.clone()..y = _goalY - 0.08;
    _velocity = Vector2(
      (target.x - _ball.x) / flightTime,
      (target.y - _ball.y) / flightTime,
    );
    _curve = (_random.nextDouble() - 0.5) * 0.55 * power;

    final keeperError = (_random.nextDouble() - 0.5) * 2.45;
    _keeperTargetX = (_aimTarget.x * 0.76 + keeperError)
        .clamp(-_goalHalfWidth + 0.58, _goalHalfWidth - 0.58)
        .toDouble();
    _diveDirection = (_keeperTargetX - _keeperX).signOrZero;
  }

  void _resolveShot() {
    final insideFrame = _ball.x.abs() < _goalHalfWidth - _ballRadius * 0.45;
    final keeperProgress = _easeOutCubic((_shotTime / 0.58).clamp(0, 1));
    final reach = 0.58 + keeperProgress * 0.58;
    final saved = insideFrame && (_ball.x - _keeperX).abs() < reach;

    if (saved) {
      final deflectSide = (_ball.x - _keeperX).signOrZero;
      final side = deflectSide == 0 ? (_random.nextBool() ? 1.0 : -1.0) : deflectSide;
      _velocity = Vector2(side * (3.2 + _random.nextDouble() * 1.4), 4.7);
      _finish(_TopDownShotState.saved);
    } else if (insideFrame) {
      _velocity = Vector2(_velocity.x * 0.16, -2.35);
      _finish(_TopDownShotState.goal);
    } else {
      _velocity = Vector2(_velocity.x * 0.45, -2.8);
      _finish(_TopDownShotState.missed);
    }
  }

  void _finish(_TopDownShotState state) {
    _state = state;
    _resultTime = 0;
  }

  void _resetRound() {
    _state = _TopDownShotState.aiming;
    _ball = Vector2(0, _ballStartY);
    _velocity = Vector2.zero();
    _aimTarget = Vector2(0, _goalY);
    _shotTime = 0;
    _resultTime = 0;
    _curve = 0;
    _diveDirection = 0;
  }

  Vector2 _targetFromCanvas(Vector2 point) {
    final pitchPoint = _pitchFromCanvas(point);
    var targetX = pitchPoint.x;
    final dy = pitchPoint.y - _ball.y;
    if (dy.abs() > 0.05) {
      final intercept = (_goalY - _ball.y) / dy;
      if (intercept > 0) {
        targetX = _ball.x + (pitchPoint.x - _ball.x) * intercept;
      }
    }
    return Vector2(
      targetX.clamp(-_goalHalfWidth - 0.9, _goalHalfWidth + 0.9).toDouble(),
      _goalY,
    );
  }

  void _drawTopDownScene(Canvas canvas) {
    _drawTopDownGoal(canvas);
    _drawTopDownKeeper(canvas);
    _drawTopDownBall(canvas);
  }

  void _drawTopDownGoal(Canvas canvas) {
    const depth = 0.96;
    const height = 1.36;
    const postColor = Color(0xFFF8FCFF);
    const backPostColor = Color(0xFFC9D2DC);
    final netFill = Paint()..color = const Color(0xFFE8F7FF).withValues(alpha: 0.15);
    final netStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, _screenScale * 0.012);

    Path panel(List<Offset> points) => Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..close();

    final backPanel = panel([
      _toGoalScreen(-_goalHalfWidth, -depth, 0),
      _toGoalScreen(_goalHalfWidth, -depth, 0),
      _toGoalScreen(_goalHalfWidth, -depth, height),
      _toGoalScreen(-_goalHalfWidth, -depth, height),
    ]);
    final roofPanel = panel([
      _toGoalScreen(-_goalHalfWidth, _goalY, height),
      _toGoalScreen(_goalHalfWidth, _goalY, height),
      _toGoalScreen(_goalHalfWidth, -depth, height),
      _toGoalScreen(-_goalHalfWidth, -depth, height),
    ]);
    final leftPanel = panel([
      _toGoalScreen(-_goalHalfWidth, _goalY, 0),
      _toGoalScreen(-_goalHalfWidth, _goalY, height),
      _toGoalScreen(-_goalHalfWidth, -depth, height),
      _toGoalScreen(-_goalHalfWidth, -depth, 0),
    ]);
    final rightPanel = panel([
      _toGoalScreen(_goalHalfWidth, _goalY, 0),
      _toGoalScreen(_goalHalfWidth, _goalY, height),
      _toGoalScreen(_goalHalfWidth, -depth, height),
      _toGoalScreen(_goalHalfWidth, -depth, 0),
    ]);

    for (final path in [backPanel, roofPanel, leftPanel, rightPanel]) {
      canvas.drawPath(path, netFill);
      canvas.drawPath(path, netStroke);
    }

    for (var i = 1; i < 18; i++) {
      final x = -_goalHalfWidth + i * (_goalHalfWidth * 2 / 18);
      _drawGoal3DLine(canvas, x, -depth, 0, x, -depth, height, netStroke);
      _drawGoal3DLine(canvas, x, _goalY, height, x, -depth, height, netStroke);
    }
    for (var i = 1; i < 9; i++) {
      final z = i * height / 9;
      _drawGoal3DLine(
        canvas,
        -_goalHalfWidth,
        -depth,
        z,
        _goalHalfWidth,
        -depth,
        z,
        netStroke,
      );
    }
    for (var i = 1; i < 5; i++) {
      final y = -depth * i / 5;
      _drawGoal3DLine(
        canvas,
        -_goalHalfWidth,
        y,
        height,
        _goalHalfWidth,
        y,
        height,
        netStroke,
      );
      _drawGoal3DLine(
        canvas,
        -_goalHalfWidth,
        y,
        0,
        -_goalHalfWidth,
        y,
        height,
        netStroke,
      );
      _drawGoal3DLine(
        canvas,
        _goalHalfWidth,
        y,
        0,
        _goalHalfWidth,
        y,
        height,
        netStroke,
      );
    }

    _drawGoalPost3D(
      canvas,
      -_goalHalfWidth,
      -depth,
      0,
      -_goalHalfWidth,
      -depth,
      height,
      backPostColor,
      0.06,
    );
    _drawGoalPost3D(
      canvas,
      _goalHalfWidth,
      -depth,
      0,
      _goalHalfWidth,
      -depth,
      height,
      backPostColor,
      0.06,
    );
    _drawGoalPost3D(
      canvas,
      -_goalHalfWidth,
      -depth,
      height,
      _goalHalfWidth,
      -depth,
      height,
      backPostColor,
      0.06,
    );
    _drawGoalPost3D(
      canvas,
      -_goalHalfWidth,
      _goalY,
      height,
      -_goalHalfWidth,
      -depth,
      height,
      backPostColor,
      0.05,
    );
    _drawGoalPost3D(
      canvas,
      _goalHalfWidth,
      _goalY,
      height,
      _goalHalfWidth,
      -depth,
      height,
      backPostColor,
      0.05,
    );

    _drawGoalPost3D(
      canvas,
      -_goalHalfWidth,
      _goalY,
      0,
      -_goalHalfWidth,
      _goalY,
      height,
      postColor,
      0.1,
    );
    _drawGoalPost3D(
      canvas,
      _goalHalfWidth,
      _goalY,
      0,
      _goalHalfWidth,
      _goalY,
      height,
      postColor,
      0.1,
    );
    _drawGoalPost3D(
      canvas,
      -_goalHalfWidth,
      _goalY,
      height,
      _goalHalfWidth,
      _goalY,
      height,
      postColor,
      0.1,
    );
  }

  void _drawTopDownKeeper(Canvas canvas) {
    final active = _state != _TopDownShotState.aiming;
    final progress = active ? _easeOutCubic((_shotTime / 0.54).clamp(0, 1)) : 0.0;
    final direction = active ? _diveDirection : 0.0;
    final foot = _toScreen(
      Vector2(_keeperX + direction * progress * 0.38, _keeperY),
    );
    final unit = _playerPixelUnit * 0.86;
    canvas.drawOval(
      Rect.fromCenter(
        center: foot + Offset(0, unit * 2.2),
        width: unit * (14 + progress * 5),
        height: unit * 4.2,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.24),
    );

    final diveSprite = _keeperDiveSprite;
    if (active && direction != 0 && progress > 0.18 && diveSprite != null) {
      _drawPixelatedSprite(
        canvas,
        diveSprite,
        foot + Offset(direction * unit * 4.0, -unit * 0.9),
        height: unit * 18.0,
        flipX: direction > 0,
        rotation: direction * 0.05,
      );
      return;
    }

    final idleSprite = _keeperIdleSprite;
    if (idleSprite != null) {
      _drawPixelatedSprite(
        canvas,
        idleSprite,
        foot,
        height: unit * (19.0 - progress * 0.8),
        anchorX: 0.52,
      );
      return;
    }

    final origin = Offset(foot.dx - unit * 7, foot.dy - unit * 17);
    final reachLeft = direction < 0 ? (progress * 3).round() : 0;
    final reachRight = direction > 0 ? (progress * 3).round() : 0;
    const outline = Color(0xFF162034);
    const jersey = Color(0xFF37CFE4);
    const jerseyDark = Color(0xFF1597A5);
    const shorts = Color(0xFF182044);
    const skin = Color(0xFFF0B38B);
    const sock = Color(0xFFF4F2F0);
    const boot = Color(0xFF171717);

    _drawPixelRect(canvas, origin, unit, 4, 0, 6, 1, outline);
    _drawPixelRect(canvas, origin, unit, 5, 1, 4, 3, skin);
    _drawPixelRect(canvas, origin, unit, 5, 1, 4, 1, const Color(0xFF4B2A20));
    _drawPixelRect(canvas, origin, unit, 4, 4, 6, 5, outline);
    _drawPixelRect(canvas, origin, unit, 5, 4, 4, 5, jersey);
    _drawPixelRect(canvas, origin, unit, 5, 8, 4, 2, jerseyDark);
    _drawPixelRect(canvas, origin, unit, 5, 9, 4, 2, shorts);

    _drawPixelRect(canvas, origin, unit, 2 - reachLeft, 5, 3, 2, outline);
    _drawPixelRect(canvas, origin, unit, 2 - reachLeft, 6, 3, 2, jersey);
    _drawPixelRect(canvas, origin, unit, 1 - reachLeft, 8, 2, 2, sock);
    _drawPixelRect(canvas, origin, unit, 9 + reachRight, 5, 3, 2, outline);
    _drawPixelRect(canvas, origin, unit, 9 + reachRight, 6, 3, 2, jersey);
    _drawPixelRect(canvas, origin, unit, 11 + reachRight, 8, 2, 2, sock);

    _drawPixelRect(canvas, origin, unit, 4, 11, 2, 4, skin);
    _drawPixelRect(canvas, origin, unit, 8, 11, 2, 4, skin);
    _drawPixelRect(canvas, origin, unit, 4, 14, 2, 3, sock);
    _drawPixelRect(canvas, origin, unit, 8, 14, 2, 3, sock);
    _drawPixelRect(canvas, origin, unit, 3, 17, 3, 1, boot);
    _drawPixelRect(canvas, origin, unit, 8, 17, 3, 1, boot);
  }

  void _drawTopDownBall(Canvas canvas) {
    final center = _toScreen(_ball);
    final radius = (_ballRadius * _screenScale).clamp(7.0, 18.0).toDouble();
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(radius * 0.26, radius * 0.34),
        width: radius * 1.65,
        height: radius * 0.7,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.22),
    );

    final sprite = _ballSprite;
    if (sprite != null) {
      _drawPixelatedSprite(
        canvas,
        sprite,
        center + Offset(0, radius),
        height: radius * 2.2,
      );
      return;
    }

    final unit = (radius / 4).clamp(1.8, 3.4).toDouble();
    final origin = Offset(center.dx - unit * 4, center.dy - unit * 4);
    const white = Color(0xFFEFEFEF);
    const gray = Color(0xFFB6BBC2);
    const dark = Color(0xFF34383F);

    _drawPixelRect(canvas, origin, unit, 2, 0, 4, 1, gray);
    _drawPixelRect(canvas, origin, unit, 1, 1, 6, 1, white);
    _drawPixelRect(canvas, origin, unit, 0, 2, 8, 4, white);
    _drawPixelRect(canvas, origin, unit, 1, 6, 6, 1, gray);
    _drawPixelRect(canvas, origin, unit, 2, 7, 4, 1, gray);
    _drawPixelRect(canvas, origin, unit, 3, 2, 2, 2, dark);
    _drawPixelRect(canvas, origin, unit, 1, 4, 2, 1, dark);
    _drawPixelRect(canvas, origin, unit, 5, 5, 2, 1, dark);
  }

  Offset _toGoalScreen(double x, double y, double z) => _toScreen(Vector2(x, y)) - Offset(0, z * _screenScale * 0.82);

  void _drawGoal3DLine(
    Canvas canvas,
    double ax,
    double ay,
    double az,
    double bx,
    double by,
    double bz,
    Paint paint,
  ) {
    canvas.drawLine(
      _toGoalScreen(ax, ay, az),
      _toGoalScreen(bx, by, bz),
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = paint.strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawGoalPost3D(
    Canvas canvas,
    double ax,
    double ay,
    double az,
    double bx,
    double by,
    double bz,
    Color color,
    double worldWidth,
  ) {
    final a = _toGoalScreen(ax, ay, az);
    final b = _toGoalScreen(bx, by, bz);
    final stroke = math.max(3.2, _screenScale * worldWidth);
    canvas.drawLine(
      a + const Offset(2, 2),
      b + const Offset(2, 2),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..strokeWidth = stroke * 1.15
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = color
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      a + Offset(-stroke * 0.16, -stroke * 0.16),
      b + Offset(-stroke * 0.16, -stroke * 0.16),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.45)
        ..strokeWidth = math.max(1.0, stroke * 0.26)
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawPixelRect(
    Canvas canvas,
    Offset origin,
    double unit,
    int x,
    int y,
    int width,
    int height,
    Color color,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(
        (origin.dx + x * unit).roundToDouble(),
        (origin.dy + y * unit).roundToDouble(),
        (width * unit).ceilToDouble(),
        (height * unit).ceilToDouble(),
      ),
      Paint()
        ..color = color
        ..isAntiAlias = false,
    );
  }

  void _drawPixelatedSprite(
    Canvas canvas,
    ui.Image image,
    Offset feet, {
    required double height,
    double anchorX = 0.5,
    bool flipX = false,
    double rotation = 0,
    double opacity = 1,
  }) {
    final width = height * image.width / image.height;
    final dst = Rect.fromLTWH(-width * anchorX, -height, width, height);
    final paint = _spritePaint(opacity)..filterQuality = FilterQuality.none;

    canvas.save();
    canvas.translate(feet.dx, feet.dy);
    canvas.rotate(rotation);
    if (flipX) {
      canvas.scale(-1, 1);
    }
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      dst,
      paint,
    );
    canvas.restore();
  }

  Vector2 _pitchFromCanvas(Vector2 point) {
    final y = _worldTopY + (point.y - _screenTop) / _screenScaleY;
    final depthScale = _depthScaleForY(y);
    return Vector2(
      (point.x - canvasSize.x / 2 - _isoSkewForY(y)) / (_screenScaleX * depthScale),
      y,
    );
  }

  Offset _toScreen(Vector2 point) {
    final depthScale = _depthScaleForY(point.y);
    return Offset(
      canvasSize.x / 2 + _isoSkewForY(point.y) + point.x * _screenScaleX * depthScale,
      _screenTop + (point.y - _worldTopY) * _screenScaleY,
    );
  }

  double get _screenTop {
    final availableHeight = math.max(
      1.0,
      canvasSize.y - _topInset - _bottomInset,
    );
    return _topInset + (availableHeight - (_worldBottomY - _worldTopY) * _screenScaleY) / 2;
  }

  double get _screenScaleX {
    final availableWidth = math.max(1.0, canvasSize.x * 0.96);
    return availableWidth / (_pitchHalfWidth * 2 * _maxDepthScale);
  }

  double get _screenScaleY {
    final availableHeight = math.max(
      1.0,
      canvasSize.y - _topInset - _bottomInset,
    );
    return availableHeight / (_worldBottomY - _worldTopY);
  }

  double get _screenScale => math.min(_screenScaleX, _screenScaleY);

  double get _maxDepthScale => 1.08;

  double _depthScaleForY(double y) {
    final normalized = ((y - _goalY) / _fieldBottomY).clamp(0.0, 1.0).toDouble();
    return 0.58 + normalized * (_maxDepthScale - 0.58);
  }

  double _isoSkewForY(double y) => (y - _fieldBottomY * 0.55) * _screenScaleX * 0.055;

  double get _playerPixelUnit => (_screenScale * 0.095).clamp(2.7, 4.8).toDouble();

  double get _topInset => math.min(86.0, canvasSize.y * 0.12);

  double get _bottomInset => math.max(22.0, canvasSize.y * 0.035);
}

enum _ShotState { aiming, flying, goal, saved, missed }

enum _KeeperDive { low, mid, high }

/// Horizontal zone the keeper dives towards, fixed at shot-resolve time.
enum _KeeperSide { left, center, right }

/// Logical motion the keeper is currently performing. Each entry maps to an
/// ordered list of atlas-cell indices in [_GoalkeeperModel._motionFrames].
///
/// The GSP render set provides NATIVE left/right/center dives — no mirror
/// flipping except [diveUpRight] reused (flipped) for upper-left saves,
/// which has no dedicated render.
enum _KeeperMotion {
  /// Loop while waiting for the shot (crouch sway, from GSP_crouch_moving).
  idle,

  /// Crouch-prep transition played once while the striker winds up.
  ready,
  diveLowLeft,
  diveLowRight,
  diveLowCenter,
  diveUpCenter,
  diveUpRight,

  /// Post-dive slide/recover after a leftward (or center) dive.
  groundLeft,

  /// Post-dive slide/recover after a rightward dive.
  groundRight,
}

/// Striker motion — each has its own atlas in `striker_v2/` (see
/// [_StrikerModel._atlasSpecs]) baked at native frame density.
enum _StrikerMotion { idle, windup, kick, settle }

class PenaltyGame extends FlameGame with TapCallbacks, DragCallbacks {
  PenaltyGame({this.onComplete, this.missesAllowed = 3});

  /// Fired exactly once, when the session ends. Carries goals, misses and the
  /// per-kick event log (for anti-cheat submit).
  final ValueChanged<TifoShootoutOutcome>? onComplete;

  /// Session ends after this many misses (BRD rule; from `/config`).
  final int missesAllowed;

  /// Live counters for the Flutter HUD panel overlaying the game
  /// (Figma 696:112029): goals scored and misses spent so far.
  final ValueNotifier<int> goalsNotifier = ValueNotifier(0);
  final ValueNotifier<int> missesNotifier = ValueNotifier(0);

  /// Fired once assets are loaded and the pitch can take a kick. The caller
  /// opens the server session at THAT moment: its expiry clock is short
  /// (liveLockTimeoutSeconds = 30 on staging), so every second spent loading
  /// sprites before the session exists is a second the player doesn't lose.
  VoidCallback? onReady;

  /// Input stays locked until the session is open — otherwise a fast player
  /// could kick before the backend knows a session exists.
  final ValueNotifier<bool> armedNotifier = ValueNotifier(false);

  bool get _armed => armedNotifier.value;

  void arm() => armedNotifier.value = true;

  /// Per-kick log + a monotonic clock, submitted to the backend which
  /// recomputes the score from these events.
  final List<TifoKickEvent> _events = [];
  final Stopwatch _sessionClock = Stopwatch()..start();

  static const double _goalZ = 23;
  // World goal dimensions are intentionally larger than a real goal so the
  // schematic hitbox lines up with the painted goal frame in
  // `stadium_goal_background.jpg` (the photo's perspective squishes
  // a regulation 7.3×2.45 m frame, so we counter-scale here).
  //
  // `_horizonY`/`_focalLength` are derived only from the photo goal's
  // WIDTH and BOTTOM (ground line) — see `_photoGoalOnStage`. The crossbar
  // (top) position is therefore a pure CONSEQUENCE of `_goalHeight` vs
  // `_goalHalfWidth`'s ratio, not something the Left/Right/Top/Bottom photo
  // constants control directly. `_goalHeight` must equal
  // `2 * _goalHalfWidth * (measured photo goal height-px / width-px)` or
  // the calibration overlay's crossbar drifts from the photo's real one —
  // measured directly off the current asset: (994-778)/(760-95) ≈ 0.3248.
  static const double _goalHalfWidth = 4.5;
  static const double _goalHeight = 2.923;
  static const double _ballRadius = 0.32;
  static const double _ballStartZ = -0.95;
  // Hand-tuned against the actual render (was 0/-1.3, which under-shot how
  // close/offset the striker needed to be) — the striker's world position
  // is static for the whole aiming/windup/kick/settle sequence (only the
  // sprite pose changes), so it must already sit right at the ball, not
  // several meters back for a run-up that never visually happens.
  static const double _strikerBaseX = -1.25;
  static const double _strikerBaseZ = -2;
  // Ball-launch delay, separate from `_StrikerModel.windupSeconds` (which
  // still paces the windup SPRITE at the source footage's real speed) —
  // gating ball movement on the full windup duration (0.667s) read as a
  // dead pause: the kick's fast swing-through is over well before that, so
  // the ball sat still noticeably after the foot had already passed
  // through it. Contact in a fast kick isn't a single frame anyway (the
  // real footage's leg crosses most of its arc in ~2 captured frames), so
  // this is tuned by feel, not re-derived from the atlas split.
  //
  // Floor here: `_ballLaunchDelay + flightTime` must clear the striker's
  // full windup+kick+settle length (`_StrikerModel.kickEndSeconds` + 0.3s
  // settle ≈ 1.2s) for EVERY shot, or `_shotTime` freezes mid-animation
  // again (the original bug). `flightTime` bottoms out at 0.84s on a
  // max-power shot (`1.18 - power*0.34`, power capped at 1.0) — 0.4 only
  // clears that by 0.04s, too tight. 0.5 gives ~0.14s of margin even on the
  // fastest shot.
  static const double _ballLaunchDelay = 0.5;
  static const double _photoKeeperVisualScale = 2;
  static const double _gravity = -9.8;
  static const double _cameraY = 3.85;
  static const double _cameraZ = -10.5;

  final _random = math.Random(8);
  final _goalkeeperModel = _GoalkeeperModel();
  final _soccerBallModel = _SoccerBallModel();
  final _strikerModel = _StrikerModel();
  ui.Image? _backgroundImage;
  final _scoreText = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      shadows: [
        Shadow(color: Color(0xAA000000), blurRadius: 4, offset: Offset(0, 1)),
      ],
    ),
  );
  final _titleText = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
      decoration: TextDecoration.underline,
      decorationColor: Color(0xFFFFFFB8),
      decorationThickness: 1.5,
      shadows: [
        Shadow(color: Color(0x99000000), blurRadius: 4, offset: Offset(0, 1)),
      ],
    ),
  );
  final _resultText = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 44,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
      shadows: [
        Shadow(color: Color(0xBB000000), blurRadius: 7, offset: Offset(0, 2)),
      ],
    ),
  );

  _ShotState _state = _ShotState.aiming;
  _Vec3 _ball = _Vec3(0, _ballRadius, _ballStartZ);
  _Vec3 _velocity = _Vec3.zero();
  _Vec3 _aimTarget = _Vec3(1.95, 1.85, _goalZ);
  Vector2? _dragStart;
  Vector2? _dragCurrent;
  String _message = '';
  double _elapsed = 0;
  double _shotTime = 0;
  double _resultTime = 0;

  /// Time since the ball actually left the foot — zero until `_shotTime`
  /// reaches [_ballLaunchDelay], then tracks it 1:1. Ball physics and the
  /// keeper's reaction/dive are keyed off THIS, not raw `_shotTime`, so
  /// they don't fire while the striker is still mid windup.
  double get _ballFlightElapsed => math.max(0.0, _shotTime - _ballLaunchDelay);
  double _keeperX = 0;
  double _keeperTargetX = 0;
  _KeeperDive _keeperDive = _KeeperDive.mid;
  _KeeperSide _keeperSide = _KeeperSide.center;
  double _spin = 0;

  /// Seconds after the kick before the keeper's dive clock starts ticking —
  /// he holds his idle stance until the ball has covered [_reactionDelayFraction]
  /// of its flight, instead of committing to a dive the instant it's struck.
  /// Computed per-shot in `_shootAtTarget` as a fraction of that shot's
  /// flight time, so faster shots still leave enough of the ~0.58s dive
  /// clock to play out before the ball arrives.
  double _reactionDelay = 0;
  static const double _reactionDelayFraction = 0.4;
  int _goals = 0;
  int _shots = 0;
  int _saves = 0;
  final List<_ShotState> _shotHistory = [];
  bool _completed = false;

  /// Recent world-space ball positions, oldest first — recorded every frame
  /// while the ball is moving (flight + post-resolve bounce/roll), rendered
  /// as a fading comet-tail behind it. Cleared at the start of each attempt.
  final List<_Vec3> _trail = [];
  static const int _trailMaxPoints = 90;

  /// Reused every segment of every frame in [_drawTrail] instead of
  /// allocating a new [Paint] per point (up to [_trailMaxPoints] per frame).
  final Paint _trailPaint = Paint()..strokeCap = StrokeCap.round;

  @override
  Color backgroundColor() => Colors.black;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Future.wait([
      _goalkeeperModel.load(),
      _soccerBallModel.load(),
      _strikerModel.load(),
    ]);
    _backgroundImage = await _loadOptionalUiImage(
      'packages/mapness/assets/tifo/backgrounds/stadium_goal_background.jpg',
    );
    onReady?.call();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_completed || !_armed) return;
    if (_state == _ShotState.aiming && _isTouchingBall(event.canvasPosition)) {
      _shootAt(event.canvasPosition, 0.74);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_completed || !_armed) return;
    if (_state != _ShotState.aiming) {
      return;
    }
    // Only a swipe that starts on the ball counts — leaving `_dragStart`
    // null here means `onDragEnd`'s `start != null` guard skips firing a
    // shot even though Flame still delivers onDragUpdate/onDragEnd for the
    // gesture (drag tracking is independent of what we do in onDragStart).
    if (!_isTouchingBall(event.canvasPosition)) {
      return;
    }
    _dragStart = event.canvasPosition.clone();
    _dragCurrent = event.canvasPosition.clone();
    _aimTarget = _targetFromCanvas(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_completed || !_armed) return;
    if (_state != _ShotState.aiming) {
      return;
    }
    _dragCurrent = event.canvasEndPosition.clone();
    _aimTarget = _targetFromCanvas(event.canvasEndPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_completed || !_armed) return;
    if (_state != _ShotState.aiming) {
      return;
    }
    final start = _dragStart;
    final end = _dragCurrent ?? start;
    if (start != null && end != null) {
      _shootFromSwipe(event.velocity, end - start);
    }
    _dragStart = null;
    _dragCurrent = null;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _dragStart = null;
    _dragCurrent = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_state == _ShotState.aiming) {
      _keeperX = math.sin(_elapsed * 1.15) * 1.65;
      return;
    }

    if (_state == _ShotState.flying) {
      _shotTime += dt;
      _keeperX += (_keeperTargetX - _keeperX) * (1 - math.exp(-dt * 4.8));
      // Ball stays put at the striker's foot until `_shotTime` reaches the
      // kick animation's contact instant (`_StrikerModel.windupSeconds`) —
      // previously it started flying from `_shotTime == 0`, i.e. the exact
      // moment of the tap/swipe, well before the windup animation had even
      // brought the foot to the ball.
      if (_ballFlightElapsed > 0) {
        _updateBall(dt);
        _recordTrailPoint();
        if (_ball.z >= _goalZ) {
          _resolveShot();
        }
        if (_ball.y < -1 || _ball.z > _goalZ + 8) {
          _finish(_ShotState.missed, 'MISS!');
        }
      }
      return;
    }

    _resultTime += dt;
    _keeperX += (_keeperTargetX - _keeperX) * (1 - math.exp(-dt * 3.5));
    _updateBall(dt, bounce: true);
    _recordTrailPoint();
    if (_resultTime > 1.65 && !_completed) {
      _resetRound();
    }
  }

  /// Appends the ball's current world position to [_trail], dropping the
  /// oldest point once the cap is hit — keeps the comet-tail render bounded
  /// regardless of how long the ball keeps rolling/bouncing after a miss.
  void _recordTrailPoint() {
    _trail.add(_ball.copy());
    if (_trail.length > _trailMaxPoints) {
      _trail.removeAt(0);
    }
  }

  @override
  void render(Canvas canvas) {
    _drawScene(canvas);
    super.render(canvas);
  }

  /// Whether [point] (canvas/screen space) lands on the ball's touch target.
  /// Mirrors `_SoccerBallModel`'s render radius (`_modelRadius * scale`,
  /// clamped 8..58) so the hit area tracks the ball's actual on-screen size
  /// as it moves toward/away from the camera, padded up for a comfortable
  /// mobile touch target (min 44dp, 1.6x the visual radius otherwise).
  bool _isTouchingBall(Vector2 point) {
    final ballScreen = _project(_ball);
    if (ballScreen == null) {
      return false;
    }
    final visualRadius = (_ballRadius * ballScreen.scale).clamp(8.0, 58.0).toDouble();
    final hitRadius = math.max(visualRadius * 1.6, 44.0);
    final ballPos = Vector2(ballScreen.offset.dx, ballScreen.offset.dy);
    return (point - ballPos).length <= hitRadius;
  }

  void _shootAt(Vector2 canvasPoint, double power) {
    _shootAtTarget(_targetFromCanvas(canvasPoint), power);
  }

  void _shootFromSwipe(Vector2 swipeVelocity, Vector2 fallbackDelta) {
    final swipe = swipeVelocity.length > 30 ? swipeVelocity : fallbackDelta;
    if (swipe.length < 1) {
      return;
    }

    final ballScreen = _project(_ball);
    if (ballScreen == null) {
      return;
    }

    final direction = swipe.normalized();
    final targetDistance = _stageRect.height * 0.48;
    final screenTarget = Vector2(
      ballScreen.offset.dx + direction.x * targetDistance,
      ballScreen.offset.dy + direction.y * targetDistance,
    );
    final power = (0.55 + swipeVelocity.length / 1800 + fallbackDelta.length / 520).clamp(0.55, 1.0).toDouble();
    _shootAtTarget(_targetFromCanvas(screenTarget), power);
  }

  void _shootAtTarget(_Vec3 target, double power) {
    unawaited(_playRandomSfx(_kickSounds));
    _aimTarget = target;
    _state = _ShotState.flying;
    _shotTime = 0;
    _resultTime = 0;
    _message = '';
    _shots++;

    final flightTime = 1.18 - power * 0.34;
    _reactionDelay = flightTime * _reactionDelayFraction;
    final flightTarget = _aimTarget.copy();
    flightTarget.z = _goalZ + 0.2;

    _velocity = _Vec3(
      (flightTarget.x - _ball.x) / flightTime,
      (flightTarget.y - _ball.y - 0.5 * _gravity * flightTime * flightTime) / flightTime,
      (flightTarget.z - _ball.z) / flightTime,
    );

    final keeperError = (_random.nextDouble() - 0.5) * 2.1;
    _keeperTargetX = (flightTarget.x * 0.72 + keeperError)
        .clamp(-_goalHalfWidth + 0.75, _goalHalfWidth - 0.75)
        .toDouble();
    _keeperDive = _chooseKeeperDive(flightTarget.y);
    // Fix the dive side once per shot — the render picks a native
    // left/right/center animation from it. This MUST be judged against the
    // shot's actual placement (_keeperTargetX, absolute — 0 = dead center
    // of the goal), not against how far the keeper has to travel from
    // wherever their idle sway (`sin(_elapsed*1.15)*1.65`) happened to
    // leave them. The old `_keeperTargetX - _keeperX` distance made a shot
    // dead center in the goal register as "left"/"right" whenever the idle
    // animation phase had the keeper leaning away from center at that
    // instant — i.e. side selection was driven by animation noise, not by
    // where the ball was actually going, which read as "always dives sideways".
    _keeperSide = _keeperTargetX.abs() < 1.0
        ? _KeeperSide.center
        : (_keeperTargetX > 0 ? _KeeperSide.right : _KeeperSide.left);
  }

  _KeeperDive _chooseKeeperDive(double targetY) {
    if (targetY < 0.95) {
      return _KeeperDive.low;
    }
    if (targetY > 1.82) {
      return _KeeperDive.high;
    }
    final roll = _random.nextDouble();
    if (targetY < 1.28 && roll < 0.46) {
      return _KeeperDive.low;
    }
    if (targetY > 1.5 && roll < 0.46) {
      return _KeeperDive.high;
    }
    return _KeeperDive.mid;
  }

  void _updateBall(double dt, {bool bounce = false}) {
    _velocity.y += _gravity * dt;
    _ball.x += _velocity.x * dt;
    _ball.y += _velocity.y * dt;
    _ball.z += _velocity.z * dt;
    _spin += _velocity.z.abs() * dt * 2.6;

    if (_ball.y <= _ballRadius) {
      _ball.y = _ballRadius;
      if (bounce && _velocity.y < -0.8) {
        _velocity.y = -_velocity.y * 0.38;
        _velocity.x *= 0.76;
        _velocity.z *= 0.74;
      } else if (_velocity.y < 0) {
        _velocity.y = 0;
      }
    }
  }

  void _resolveShot() {
    final insideFrame =
        _ball.x.abs() < _goalHalfWidth - _ballRadius * 0.4 &&
        _ball.y > _ballRadius * 0.8 &&
        _ball.y < _goalHeight - _ballRadius * 0.15;

    // Dynamic hitbox — reach grows from "just standing there" to the dive
    // style's full extension as the *actual* on-screen dive completes,
    // mirroring the delayed reaction clock in `_drawKeeper` (actionTime =
    // _ballFlightElapsed - _reactionDelay, same easeOutCubic ramp). Without
    // this, a fast shot arriving before the delayed dive finishes would
    // still get saved by the old fixed-size box even though the keeper
    // visibly hasn't gotten there yet.
    final actionTime = math.max(0.0, _ballFlightElapsed - _reactionDelay);
    final diveProgress = _keeperSide == _KeeperSide.center
        ? 0.0 // never dives — stays at his standing reach the whole shot.
        : _easeOutCubic((actionTime / 0.58).clamp(0.0, 1.0));

    const standReachX = 0.42;
    final maxReachX = switch (_keeperDive) {
      _KeeperDive.low => 0.95,
      _KeeperDive.mid => 0.78,
      _KeeperDive.high => 0.62,
    };
    final reachX = standReachX + (maxReachX - standReachX) * diveProgress;

    // Vertical reach band centers on the dive style's target height and
    // widens as the dive completes — a low dive can't cover a crossbar
    // shot, and a half-committed dive covers less than a finished one.
    final reachCenterY = switch (_keeperDive) {
      _KeeperDive.low => 0.55,
      _KeeperDive.mid => 1.15,
      _KeeperDive.high => 1.85,
    };
    const standReachY = 0.55;
    final maxReachY = switch (_keeperDive) {
      _KeeperDive.low => 0.95,
      _KeeperDive.mid => 1.15,
      _KeeperDive.high => 1.05,
    };
    final reachY = standReachY + (maxReachY - standReachY) * diveProgress;

    final direction = (_keeperTargetX - _keeperX).signOrZero;
    final reachCenterX = _keeperX + direction * diveProgress * 0.32;
    final keeperReachX = (_ball.x - reachCenterX).abs();
    final keeperReachY = (_ball.y - reachCenterY).abs();
    final saved = keeperReachX < reachX && keeperReachY < reachY && _ball.y < _goalHeight;

    if (saved) {
      _saves++;
      _velocity = _Vec3((_ball.x - _keeperX).signOrZero * 3.1, 2.2, -5.1);
      _finish(_ShotState.saved, 'SAVE!');
    } else if (insideFrame) {
      _goals++;
      _velocity.x *= 0.22;
      _velocity.y *= 0.12;
      _velocity.z *= 0.22;
      _finish(_ShotState.goal, 'GOAL!');
    } else {
      _finish(_ShotState.missed, 'MISS!');
    }
  }

  void _finish(_ShotState state, String message) {
    _state = state;
    _message = message;
    _resultTime = 0;
    _shotHistory.add(state);

    // Record the kick for the anti-cheat event log. Only `goal` counts as
    // scored; both `saved` and `missed` are misses.
    final scored = state == _ShotState.goal;
    _events.add(
      TifoKickEvent(index: _events.length, scored: scored, atMs: _sessionClock.elapsedMilliseconds),
    );
    final misses = _shotHistory.where((s) => s != _ShotState.goal).length;
    goalsNotifier.value = _goals;
    missesNotifier.value = misses;
    logger.log(
      '[tifo-game] kick #${_shotHistory.length}: ${state.name} → scored=$_goals '
      'misses=$misses/$missesAllowed',
    );

    // Ends ONLY on the Nth miss (BRD FR-11: "no kick limit"). An extra
    // client-side attempt cap used to cut good runs short at 5 shots, and the
    // backend rejects a log that doesn't end on the allowed miss — every such
    // session came back `voided` with the token spent (reproduced on staging:
    // 3 goals / 2 misses → voided, same run with the 3rd miss → claimed).
    if (!_completed && misses >= missesAllowed) {
      _completed = true;
      logger.log('[tifo-game] session ended: scored=$_goals misses=$misses shots=${_shotHistory.length}');
      onComplete?.call(TifoShootoutOutcome(goals: _goals, misses: misses, events: List.unmodifiable(_events)));
    }
  }

  void _resetRound() {
    _state = _ShotState.aiming;
    _ball = _Vec3(0, _ballRadius, _ballStartZ);
    _velocity = _Vec3.zero();
    _aimTarget = _Vec3(1.95, 1.85, _goalZ);
    _message = '';
    _shotTime = 0;
    _resultTime = 0;
    _keeperDive = _KeeperDive.mid;
    _trail.clear();
  }

  _Vec3 _targetFromCanvas(Vector2 point) {
    const depth = _goalZ - _cameraZ;
    final scale = _focalLength / depth;
    final x = ((point.x - _centerX) / scale).clamp(-_goalHalfWidth - 0.8, _goalHalfWidth + 0.8).toDouble();
    final y = (_cameraY - (point.y - _horizonY) / scale).clamp(0.45, _goalHeight + 0.75).toDouble();
    return _Vec3(x, y, _goalZ);
  }

  void _drawScene(Canvas canvas) {
    _drawOuterBackground(canvas);
    canvas.save();
    canvas.clipRRect(_stageRRect);
    _drawBackground(canvas);
    if (_backgroundImage == null) {
      _drawField(canvas);
      _drawGoal(canvas);
    } else {
      // QA overlay — red outline of the *programmatic* goal frame (world
      // `x = ±_goalHalfWidth`, `y = 0..._goalHeight` at `z = _goalZ`) so
      // any drift between the photo's painted goal and the calibration in
      // `_photoGoalOnStage`/`_centerX`/`_horizonY`/`_focalLength` is
      // immediately visible. Remove once alignment is confirmed on device.
      _drawGoalCalibrationOverlay(canvas);
    }
    _drawKeeper(canvas);
    _drawTrail(canvas);
    _drawBall(canvas);
    _drawPlayer(canvas);
    _drawHud(canvas);
    canvas.restore();
    _drawStageBorder(canvas);
  }

  /// Fading comet-tail behind the ball — a breadcrumb of [_trail] points,
  /// oldest (near-transparent) to newest (brightest, right behind the ball).
  /// Drawn before [_drawBall] so the sprite sits cleanly on top of its tail.
  void _drawTrail(Canvas canvas) {
    if (_trail.length < 2) {
      return;
    }
    _Projected? previous;
    final last = _trail.length - 1;
    for (var i = 0; i <= last; i++) {
      final current = _project(_trail[i]);
      if (previous != null && current != null) {
        final age = i / last;
        _trailPaint
          ..color = Colors.white.withValues(alpha: age * age * 0.5)
          ..strokeWidth = math.max(
            1.5,
            _ballRadius * 0.5 * (previous.scale + current.scale) * 0.5,
          );
        canvas.drawLine(previous.offset, current.offset, _trailPaint);
      }
      previous = current;
    }
  }

  void _drawOuterBackground(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, canvasSize.x, canvasSize.y);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF151515));
  }

  void _drawBackground(Canvas canvas) {
    final rect = _stageRect;
    final background = _backgroundImage;
    if (background != null) {
      _drawCoverImage(canvas, background, rect);
      return;
    }

    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8DC7EF), Color(0xFFBDE4FA), Color(0xFFEEF8FF)],
        stops: [0, 0.58, 1],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunCenter = Offset(
      rect.left + rect.width * 0.82,
      rect.top + rect.height * 0.12,
    );
    final sunRadius = (rect.shortestSide * 0.055).clamp(24.0, 42.0).toDouble();
    canvas.drawCircle(
      sunCenter,
      sunRadius * 1.25,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                const Color(0xFFFFFFBF).withValues(alpha: 0.52),
                const Color(0xFFFFFFBF).withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(center: sunCenter, radius: sunRadius * 1.25),
            ),
    );
    canvas.drawCircle(
      sunCenter,
      sunRadius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFFFCA), Color(0xFFE9F4BE)],
        ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius)),
    );

    final standTop = rect.top + rect.height * 0.365;
    final standBottom = rect.top + rect.height * 0.49;
    canvas.drawRect(
      Rect.fromLTRB(rect.left, standTop, rect.right, standBottom),
      Paint()
        ..shader =
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF243547), Color(0xFF172638), Color(0xFF22364B)],
            ).createShader(
              Rect.fromLTRB(rect.left, standTop, rect.right, standBottom),
            ),
    );
    canvas.drawRect(
      Rect.fromLTRB(
        rect.left,
        standTop,
        rect.right,
        standTop + rect.height * 0.018,
      ),
      Paint()..color = const Color(0xFF172333),
    );

    final seatPaint = Paint()..color = const Color(0xFF6E8EA5).withValues(alpha: 0.42);
    final seatTop = standTop + rect.height * 0.033;
    final seatHeight = math.max(4.0, rect.height * 0.01);
    final seatWidth = rect.width * 0.04;
    for (var i = -1; i < 16; i++) {
      final left = rect.left + i * rect.width * 0.085 + rect.width * 0.01;
      canvas.drawRect(
        Rect.fromLTWH(left, seatTop, seatWidth, seatHeight),
        seatPaint,
      );
    }

    final rowPaint = Paint()..color = const Color(0xFF9DB8C8).withValues(alpha: 0.2);
    for (var i = 1; i < 5; i++) {
      final y = standTop + i * (standBottom - standTop) / 5;
      canvas.drawLine(
        Offset(rect.left, y),
        Offset(rect.right, y + rect.height * 0.006),
        rowPaint..strokeWidth = 1,
      );
    }

    final apron = Rect.fromLTRB(
      rect.left,
      standBottom,
      rect.right,
      rect.bottom,
    );
    canvas.drawRect(
      apron,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE9F8FF), Color(0xFF9BB6C7), Color(0xFF38576E)],
          stops: [0, 0.62, 1],
        ).createShader(apron),
    );
  }

  void _drawCoverImage(Canvas canvas, ui.Image image, Rect rect) {
    final scale = math.max(
      rect.width / image.width,
      rect.height / image.height,
    );
    final sourceWidth = rect.width / scale;
    final sourceHeight = rect.height / scale;
    final sourceLeft = ((image.width - sourceWidth) / 2).clamp(
      0.0,
      image.width.toDouble(),
    );
    final sourceTop = ((image.height - sourceHeight) * 0.46).clamp(
      0.0,
      image.height.toDouble(),
    );
    final source = Rect.fromLTWH(
      sourceLeft,
      sourceTop,
      math.min(sourceWidth, image.width.toDouble()),
      math.min(sourceHeight, image.height.toDouble()),
    );
    canvas.drawImageRect(
      image,
      source,
      rect,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  void _drawField(Canvas canvas) {
    const nearZ = -4.4;
    const farZ = _goalZ + 4.1;
    const grassA = Color(0xFF53AF61);
    const grassB = Color(0xFF459D52);

    final fieldPath = Path();
    final fieldCorners = [
      _Vec3(-_fieldHalfWidth(nearZ), 0, nearZ),
      _Vec3(_fieldHalfWidth(nearZ), 0, nearZ),
      _Vec3(_fieldHalfWidth(farZ), 0, farZ),
      _Vec3(-_fieldHalfWidth(farZ), 0, farZ),
    ].map(_project).whereType<_Projected>().toList();
    if (fieldCorners.length != 4) {
      return;
    }
    fieldPath
      ..moveTo(fieldCorners[0].offset.dx, fieldCorners[0].offset.dy)
      ..lineTo(fieldCorners[1].offset.dx, fieldCorners[1].offset.dy)
      ..lineTo(fieldCorners[2].offset.dx, fieldCorners[2].offset.dy)
      ..lineTo(fieldCorners[3].offset.dx, fieldCorners[3].offset.dy)
      ..close();
    canvas.drawPath(fieldPath, Paint()..color = grassA);

    for (var i = 0; i < 12; i++) {
      final z0 = nearZ + (farZ - nearZ) * i / 12;
      final z1 = nearZ + (farZ - nearZ) * (i + 1) / 12;
      final color = i.isEven ? grassA : grassB;
      _drawWorldPolygon(canvas, [
        _Vec3(-_fieldHalfWidth(z0), 0.01, z0),
        _Vec3(_fieldHalfWidth(z0), 0.01, z0),
        _Vec3(_fieldHalfWidth(z1), 0.01, z1),
        _Vec3(-_fieldHalfWidth(z1), 0.01, z1),
      ], color);
    }

    final bladePaint = Paint()
      ..color = const Color(0xFF90D291).withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (var i = 0; i < 80; i++) {
      final z = nearZ + (farZ - nearZ) * ((i * 37 % 100) / 100);
      final x = -_fieldHalfWidth(z) + _fieldHalfWidth(z) * 2 * ((i * 53 % 100) / 100);
      final projected = _project(_Vec3(x, 0.025, z));
      if (projected != null) {
        canvas.drawLine(
          projected.offset,
          projected.offset + Offset(projected.scale * 0.03, 0),
          bladePaint,
        );
      }
    }

    final lineColor = Colors.white.withValues(alpha: 0.48);
    _drawWorldLine(
      canvas,
      _Vec3(-_fieldHalfWidth(nearZ), 0.045, nearZ),
      _Vec3(-_fieldHalfWidth(farZ), 0.045, farZ),
      const Color(0xFFCDE7FF),
      0.04,
    );
    _drawWorldLine(
      canvas,
      _Vec3(_fieldHalfWidth(nearZ), 0.045, nearZ),
      _Vec3(_fieldHalfWidth(farZ), 0.045, farZ),
      const Color(0xFFCDE7FF),
      0.04,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-_fieldHalfWidth(farZ), 0.045, farZ),
      _Vec3(_fieldHalfWidth(farZ), 0.045, farZ),
      lineColor,
      0.026,
    );

    _drawPitchRect(
      canvas,
      halfWidth: 4.7,
      zNear: _goalZ - 5.4,
      zFar: _goalZ + 0.1,
      color: lineColor,
    );
    _drawPitchRect(
      canvas,
      halfWidth: 2.35,
      zNear: _goalZ - 2.45,
      zFar: _goalZ + 0.02,
      color: lineColor.withValues(alpha: 0.44),
    );
    _drawGroundCircle(
      canvas,
      _Vec3(0, 0.05, _goalZ - 6.45),
      0.7,
      lineColor.withValues(alpha: 0.5),
      0.022,
    );
    _drawGroundCircle(
      canvas,
      _Vec3(0, 0.05, _ball.z),
      0.33,
      Colors.white.withValues(alpha: 0.7),
      0.028,
    );
  }

  void _drawPitchRect(
    Canvas canvas, {
    required double halfWidth,
    required double zNear,
    required double zFar,
    required Color color,
  }) {
    _drawWorldLine(
      canvas,
      _Vec3(-halfWidth, 0.05, zNear),
      _Vec3(halfWidth, 0.05, zNear),
      color,
      0.022,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-halfWidth, 0.05, zNear),
      _Vec3(-halfWidth, 0.05, zFar),
      color,
      0.022,
    );
    _drawWorldLine(
      canvas,
      _Vec3(halfWidth, 0.05, zNear),
      _Vec3(halfWidth, 0.05, zFar),
      color,
      0.022,
    );
  }

  void _drawGroundCircle(
    Canvas canvas,
    _Vec3 center,
    double radius,
    Color color,
    double worldWidth,
  ) {
    _Projected? previous;
    for (var i = 0; i <= 48; i++) {
      final angle = math.pi * 2 * i / 48;
      final current = _project(
        _Vec3(
          center.x + math.cos(angle) * radius,
          center.y,
          center.z + math.sin(angle) * radius,
        ),
      );
      if (previous != null && current != null) {
        final stroke = math.max(
          1.0,
          worldWidth * (previous.scale + current.scale) * 0.5,
        );
        canvas.drawLine(
          previous.offset,
          current.offset,
          Paint()
            ..color = color
            ..strokeWidth = stroke
            ..strokeCap = StrokeCap.round,
        );
      }
      previous = current;
    }
  }

  /// Red outline of the goal frame as computed by [_project] — crossbar,
  /// both posts, and a ground-line hint. Purely a calibration aid: on a
  /// correctly-calibrated photo this should trace exactly over the photo's
  /// own painted (white) goalposts. Any gap or offset means
  /// `_photoGoalSrcLeft/Right/Top/Bottom` need re-measuring against the
  /// current `stadium_goal_background.jpg`.
  void _drawGoalCalibrationOverlay(Canvas canvas) {
    final lt = _project(_Vec3(-_goalHalfWidth, _goalHeight, _goalZ));
    final rt = _project(_Vec3(_goalHalfWidth, _goalHeight, _goalZ));
    final lb = _project(_Vec3(-_goalHalfWidth, 0, _goalZ));
    final rb = _project(_Vec3(_goalHalfWidth, 0, _goalZ));
    if (lt == null || rt == null || lb == null || rb == null) {
      return;
    }

    const red = Color(0xFFFF3B30);
    final post = Paint()
      ..color = red.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final groundLine = Paint()
      ..color = red.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Crossbar.
    canvas.drawLine(lt.offset, rt.offset, post);
    // Left post.
    canvas.drawLine(lt.offset, lb.offset, post);
    // Right post.
    canvas.drawLine(rt.offset, rb.offset, post);
    // Goal-line on the turf — thinner / dimmer hint.
    canvas.drawLine(lb.offset, rb.offset, groundLine);
  }

  void _drawGoal(Canvas canvas) {
    final netColor = Colors.white.withValues(alpha: 0.42);
    const netBackZ = _goalZ + 1.25;

    for (var i = 0; i <= 10; i++) {
      final x = -_goalHalfWidth + i * (_goalHalfWidth * 2 / 10);
      _drawWorldLine(
        canvas,
        _Vec3(x, 0, _goalZ),
        _Vec3(x, _goalHeight, netBackZ),
        netColor,
        0.012,
      );
    }
    for (var i = 0; i <= 6; i++) {
      final y = i * _goalHeight / 6;
      _drawWorldLine(
        canvas,
        _Vec3(-_goalHalfWidth, y, _goalZ),
        _Vec3(_goalHalfWidth, y, _goalZ),
        netColor,
        0.012,
      );
      _drawWorldLine(
        canvas,
        _Vec3(-_goalHalfWidth, y, netBackZ),
        _Vec3(_goalHalfWidth, y, netBackZ),
        netColor.withValues(alpha: 0.28),
        0.01,
      );
    }
    for (var i = 0; i <= 5; i++) {
      final x = -_goalHalfWidth + i * (_goalHalfWidth * 2 / 5);
      _drawWorldLine(
        canvas,
        _Vec3(x, 0.04, _goalZ),
        _Vec3(x - 0.2, _goalHeight, netBackZ),
        netColor.withValues(alpha: 0.22),
        0.006,
      );
    }

    final postColor = Colors.white.withValues(alpha: 0.96);
    final shadowColor = Colors.black.withValues(alpha: 0.18);
    _drawWorldLine(
      canvas,
      _Vec3(-_goalHalfWidth + 0.04, -0.02, _goalZ + 0.04),
      _Vec3(-_goalHalfWidth + 0.04, _goalHeight - 0.02, _goalZ + 0.04),
      shadowColor,
      0.13,
    );
    _drawWorldLine(
      canvas,
      _Vec3(_goalHalfWidth + 0.04, -0.02, _goalZ + 0.04),
      _Vec3(_goalHalfWidth + 0.04, _goalHeight - 0.02, _goalZ + 0.04),
      shadowColor,
      0.13,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-_goalHalfWidth + 0.04, _goalHeight - 0.02, _goalZ + 0.04),
      _Vec3(_goalHalfWidth + 0.04, _goalHeight - 0.02, _goalZ + 0.04),
      shadowColor,
      0.13,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-_goalHalfWidth, 0, _goalZ),
      _Vec3(-_goalHalfWidth, _goalHeight, _goalZ),
      postColor,
      0.12,
    );
    _drawWorldLine(
      canvas,
      _Vec3(_goalHalfWidth, 0, _goalZ),
      _Vec3(_goalHalfWidth, _goalHeight, _goalZ),
      postColor,
      0.12,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-_goalHalfWidth, _goalHeight, _goalZ),
      _Vec3(_goalHalfWidth, _goalHeight, _goalZ),
      postColor,
      0.12,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-_goalHalfWidth, 0, _goalZ),
      _Vec3(-_goalHalfWidth, 0, netBackZ),
      postColor.withValues(alpha: 0.5),
      0.065,
    );
    _drawWorldLine(
      canvas,
      _Vec3(_goalHalfWidth, 0, _goalZ),
      _Vec3(_goalHalfWidth, 0, netBackZ),
      postColor.withValues(alpha: 0.5),
      0.065,
    );
    _drawWorldLine(
      canvas,
      _Vec3(-_goalHalfWidth, _goalHeight, netBackZ),
      _Vec3(_goalHalfWidth, _goalHeight, netBackZ),
      postColor.withValues(alpha: 0.45),
      0.052,
    );
  }

  void _drawKeeper(Canvas canvas) {
    const z = _goalZ - 0.68;
    final isReacting = _state != _ShotState.aiming;
    // Hold the idle stance until the ball has covered _reactionDelay of its
    // OWN flight (`_ballFlightElapsed`, zeroed until the kick's contact
    // instant) — the striker's kick animation, driven separately by raw
    // `_shotTime` in `_drawPlayer`, still plays immediately on tap. Once
    // the result phase starts (state flips to saved/missed/goal),
    // `_ballFlightElapsed` has long since passed the delay, so this has no
    // effect there — the result-phase branch in `_renderSprite` doesn't
    // gate on `actionTime` anyway.
    final actionTime = math.max(0.0, _ballFlightElapsed - _reactionDelay);
    final direction = isReacting ? (_keeperTargetX - _keeperX).signOrZero : 0.0;
    final progress = isReacting ? _easeOutCubic((actionTime / 0.58).clamp(0, 1)) : 0.0;
    final lift =
        switch (_keeperDive) {
          _KeeperDive.low => 0.02,
          _KeeperDive.mid => 0.14,
          _KeeperDive.high => 0.3,
        } *
        progress;
    _goalkeeperModel.render(
      this,
      canvas,
      base: _Vec3(
        _keeperX + direction * progress * 0.32,
        0,
        z - progress * 0.1,
      ),
      dive: direction * progress,
      lift: lift,
      actionTime: actionTime,
      diveStyle: _keeperDive,
      diveSide: _keeperSide,
      reacting: isReacting,
      visualScale: _backgroundImage == null ? 1.0 : _photoKeeperVisualScale,
      shotState: _state,
      resultTime: _resultTime,
    );
  }

  void _drawPlayer(Canvas canvas) {
    _strikerModel.render(
      this,
      canvas,
      base: _Vec3(_strikerBaseX, 0, _strikerBaseZ),
      state: _state,
      shotTime: _shotTime,
      elapsed: _elapsed,
      resultTime: _resultTime,
    );
  }

  void _drawBall(Canvas canvas) {
    _soccerBallModel.render(this, canvas, center: _ball, spin: _spin);
  }

  void _drawHud(Canvas canvas) {
    // Counters live in the Flutter info panel (_PenaltyHudPanel) — only the
    // GOAL!/SAVE!/MISS! flash is still drawn in-canvas.
    if (_message.isEmpty) {
      return;
    }
    final stage = _stageRect;
    final alpha = (1 - (_resultTime / 1.65)).clamp(0.0, 1.0).toDouble();
    final position = Vector2(stage.center.dx, stage.top + stage.height * 0.22);
    // Bound the offscreen compositing layer to the text's own footprint
    // (`_message` is constant for the whole flash, so this hits `TextPaint`'s
    // internal cache — no relayout) instead of the full canvas. A
    // screen-sized `saveLayer` every frame for ~1.65s was allocating/
    // compositing a full-screen GPU layer just to fade one line of text;
    // padding covers the text's drop shadow so it isn't clipped.
    final textSize = _resultText.toTextPainter(_message).size;
    final bounds = Rect.fromCenter(
      center: Offset(position.x, position.y),
      width: textSize.width,
      height: textSize.height,
    ).inflate(32);
    canvas.saveLayer(bounds, Paint()..color = Colors.white.withValues(alpha: alpha));
    _resultText.render(canvas, _message, position, anchor: Anchor.center);
    canvas.restore();
  }

  void _drawStageBorder(Canvas canvas) {
    final rrect = _stageRRect;
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  void _drawWorldPolygon(Canvas canvas, List<_Vec3> points, Color color) {
    final projected = points.map(_project).whereType<_Projected>().toList();
    if (projected.length != points.length) {
      return;
    }
    final path = Path()..moveTo(projected.first.offset.dx, projected.first.offset.dy);
    for (final point in projected.skip(1)) {
      path.lineTo(point.offset.dx, point.offset.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawWorldLine(
    Canvas canvas,
    _Vec3 a,
    _Vec3 b,
    Color color,
    double worldWidth,
  ) {
    final pa = _project(a);
    final pb = _project(b);
    if (pa == null || pb == null) {
      return;
    }
    final stroke = math.max(1.0, worldWidth * (pa.scale + pb.scale) * 0.5);
    canvas.drawLine(
      pa.offset,
      pb.offset,
      Paint()
        ..color = color
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawShadow(Canvas canvas, _Vec3 center, double radius, double alpha) {
    final projected = _project(_Vec3(center.x, 0.02, center.z));
    if (projected == null) {
      return;
    }
    final width = radius * projected.scale * 2.2;
    final height = radius * projected.scale * 0.55;
    canvas.drawOval(
      Rect.fromCenter(center: projected.offset, width: width, height: height),
      Paint()..color = Colors.black.withValues(alpha: alpha),
    );
  }

  void _drawCapsule(
    Canvas canvas,
    _Vec3 a,
    _Vec3 b,
    double radius,
    Color color, {
    Color? endColor,
  }) {
    final limbColor = endColor ?? color;
    _drawWorldLine(canvas, a, b, _darken(color, 0.08), radius * 2.2);
    _drawWorldLine(canvas, a, b, color, radius * 1.64);
    _drawWorldSphere(canvas, a, radius * 0.92, _lighten(color, 0.08));
    _drawWorldSphere(canvas, b, radius, limbColor);
  }

  void _drawWorldOval(
    Canvas canvas,
    _Vec3 center,
    double width,
    double height,
    Color color, {
    double tilt = 0,
  }) {
    final projected = _project(center);
    if (projected == null) {
      return;
    }
    final rect = Rect.fromCenter(
      center: projected.offset,
      width: math.max(2, width * projected.scale),
      height: math.max(2, height * projected.scale),
    );
    canvas.save();
    canvas.translate(projected.offset.dx, projected.offset.dy);
    canvas.rotate(tilt);
    canvas.translate(-projected.offset.dx, -projected.offset.dy);
    canvas.drawOval(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.42),
          colors: [_lighten(color, 0.2), color, _darken(color, 0.18)],
        ).createShader(rect),
    );
    canvas.restore();
  }

  void _drawJerseyTorso(
    Canvas canvas,
    _Vec3 center,
    double lean,
    Color baseColor,
  ) {
    final shoulders = [
      _Vec3(center.x - 0.52 + lean * 0.14, center.y + 0.55, center.z),
      _Vec3(center.x + 0.52 + lean * 0.14, center.y + 0.55, center.z),
      _Vec3(center.x + 0.35 - lean * 0.08, center.y - 0.48, center.z - 0.02),
      _Vec3(center.x - 0.35 - lean * 0.08, center.y - 0.48, center.z - 0.02),
    ];
    _drawWorldPolygon(canvas, shoulders, _darken(baseColor, 0.04));

    final chest = [
      _Vec3(center.x - 0.38 + lean * 0.12, center.y + 0.42, center.z - 0.04),
      _Vec3(center.x + 0.38 + lean * 0.12, center.y + 0.42, center.z - 0.04),
      _Vec3(center.x + 0.25 - lean * 0.06, center.y - 0.34, center.z - 0.05),
      _Vec3(center.x - 0.25 - lean * 0.06, center.y - 0.34, center.z - 0.05),
    ];
    _drawWorldPolygon(canvas, chest, _lighten(baseColor, 0.06));

    for (final offset in [-0.22, 0.0, 0.22]) {
      _drawWorldLine(
        canvas,
        _Vec3(
          center.x + offset + lean * 0.08,
          center.y + 0.35,
          center.z - 0.07,
        ),
        _Vec3(
          center.x + offset - lean * 0.05,
          center.y - 0.32,
          center.z - 0.07,
        ),
        Colors.white.withValues(alpha: 0.3),
        0.018,
      );
    }
  }

  void _drawWorldSphere(
    Canvas canvas,
    _Vec3 center,
    double radius,
    Color color,
  ) {
    final projected = _project(center);
    if (projected == null) {
      return;
    }
    final r = math.max(2.0, radius * projected.scale);
    canvas.drawCircle(
      projected.offset,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.45, -0.45),
          colors: [_lighten(color, 0.22), color, _darken(color, 0.18)],
        ).createShader(Rect.fromCircle(center: projected.offset, radius: r)),
    );
  }

  void _drawBox(Canvas canvas, _Vec3 center, _Vec3 size, Color color) {
    final hx = size.x / 2;
    final hy = size.y / 2;
    final hz = size.z / 2;
    final corners = [
      _Vec3(center.x - hx, center.y - hy, center.z - hz),
      _Vec3(center.x + hx, center.y - hy, center.z - hz),
      _Vec3(center.x + hx, center.y + hy, center.z - hz),
      _Vec3(center.x - hx, center.y + hy, center.z - hz),
      _Vec3(center.x - hx, center.y - hy, center.z + hz),
      _Vec3(center.x + hx, center.y - hy, center.z + hz),
      _Vec3(center.x + hx, center.y + hy, center.z + hz),
      _Vec3(center.x - hx, center.y + hy, center.z + hz),
    ];

    void face(List<int> indexes, Color faceColor) {
      _drawWorldPolygon(
        canvas,
        indexes.map((index) => corners[index]).toList(),
        faceColor,
      );
    }

    face([4, 5, 6, 7], _darken(color, 0.16));
    face([0, 4, 7, 3], _darken(color, 0.06));
    face([1, 5, 6, 2], _darken(color, 0.12));
    face([3, 2, 6, 7], _lighten(color, 0.08));
    face([0, 1, 2, 3], color);
  }

  _Projected? _project(_Vec3 point) {
    final depth = point.z - _cameraZ;
    if (depth <= 0.1) {
      return null;
    }
    final scale = _focalLength / depth;
    return _Projected(
      Offset(
        _centerX + point.x * scale,
        _horizonY - (point.y - _cameraY) * scale,
      ),
      scale,
    );
  }

  double _fieldHalfWidth(double z) => 5.4 + z.clamp(0, _goalZ + 5).toDouble() * 0.12;

  Rect get _stageRect => Rect.fromLTWH(
    0,
    0,
    math.max(1.0, canvasSize.x),
    math.max(1.0, canvasSize.y),
  );

  RRect get _stageRRect => RRect.fromRectAndRadius(_stageRect, Radius.circular(_stageRadius));

  double get _stageRadius => math.min(
    16.0,
    math.max(10.0, math.min(canvasSize.x, canvasSize.y) * 0.03),
  );

  // ─── Photo-fitted projection ───────────────────────────────────────────
  //
  // The world projection is anchored to the painted goal inside
  // `stadium_goal_background.jpg` so the schematic hitbox lines up
  // pixel-accurately on every screen size / aspect ratio / DPI.
  //
  // 1. Source image is `_photoIntrinsicWidth × _photoIntrinsicHeight`.
  //    The painted goal-frame inside that image is at
  //    `[_photoGoalSrcLeft … _photoGoalSrcRight] × [Top … Bottom]`.
  //    These are measured once from the asset and are absolute pixel
  //    constants — they do NOT depend on the device.
  // 2. `_photoGoalOnStage()` mirrors the BoxFit.cover crop logic from
  //    [_drawCoverImage] to map those source pixels to current
  //    logical-screen coordinates.
  // 3. `_focalLength` / `_horizonY` / `_centerX` are computed so the
  //    world goal `(±_goalHalfWidth, [0, _goalHeight], _goalZ)`
  //    projects exactly onto the photo's painted goal — width matches
  //    the post separation, and y=0 lands on the photo's goal-line.
  //    Crossbar match accuracy depends on `_goalHeight / 2_goalHalfWidth`
  //    matching the photo's aspect (an aesthetic choice).
  //
  // Procedural fallback (no photo) keeps the original arbitrary
  // multipliers (`1.24`, `0.4`) since it doesn't need to align with a
  // photo, and the goal there is drawn in code at the world coords.

  // Intrinsic dimensions of stadium_goal_background.jpg, in source px.
  static const double _photoIntrinsicWidth = 853;
  static const double _photoIntrinsicHeight = 1844;
  // Painted goal frame inside that image, in source px. Re-measured
  // directly off stadium_goal_background.jpg (outer post edges / crossbar
  // top / ground contact) — the previous constants (90/711/742/991) were
  // off by up to ~49px horizontally and ~33px vertically, which is what
  // made the schematic hitbox overlay visibly not line up with the photo.
  static const double _photoGoalSrcLeft = 95;
  static const double _photoGoalSrcRight = 760;
  static const double _photoGoalSrcTop = 778;
  static const double _photoGoalSrcBottom = 994;
  // Vertical bias used by `_drawCoverImage` (must stay in sync).
  static const double _photoCropVerticalBias = 0.46;

  /// Where the painted goal of the background photo lands on screen,
  /// after `BoxFit.cover` crop on the current stage. Returns logical-px
  /// coordinates that adapt to screen size / aspect ratio.
  Rect _photoGoalOnStage() {
    final stage = _stageRect;
    final scale = math.max(
      stage.width / _photoIntrinsicWidth,
      stage.height / _photoIntrinsicHeight,
    );
    final sourceWidth = stage.width / scale;
    final sourceHeight = stage.height / scale;
    final sourceLeft = ((_photoIntrinsicWidth - sourceWidth) / 2).clamp(0.0, _photoIntrinsicWidth);
    final sourceTop = ((_photoIntrinsicHeight - sourceHeight) * _photoCropVerticalBias).clamp(
      0.0,
      _photoIntrinsicHeight,
    );
    return Rect.fromLTRB(
      (_photoGoalSrcLeft - sourceLeft) * scale,
      (_photoGoalSrcTop - sourceTop) * scale,
      (_photoGoalSrcRight - sourceLeft) * scale,
      (_photoGoalSrcBottom - sourceTop) * scale,
    );
  }

  double get _centerX {
    if (_backgroundImage == null) {
      return _stageRect.center.dx;
    }
    return _photoGoalOnStage().center.dx;
  }

  double get _horizonY {
    if (_backgroundImage == null) {
      return _stageRect.top + _stageRect.height * 0.4;
    }
    final goalRect = _photoGoalOnStage();
    // Match world post separation → photo post separation, then derive
    // horizon so world y=0 projects to the photo's goal-line.
    final scale = goalRect.width / (2 * _goalHalfWidth);
    return goalRect.bottom - _cameraY * scale;
  }

  double get _focalLength {
    if (_backgroundImage == null) {
      return _stageRect.height * 1.24;
    }
    final goalRect = _photoGoalOnStage();
    return goalRect.width * (_goalZ - _cameraZ) / (2 * _goalHalfWidth);
  }
}

class _StrikerModel {
  // Preferred path: one small atlas PER MOTION, baked at native frame
  // density from the SP_idle/SP_kick render sets (see _atlasSpecs — frame
  // counts vary 8..20 depending on how much real footage each phase has).
  // Real per-frame art replaces the old single-pose-plus-procedural-skew
  // rig below, which now only serves as a fallback.
  final Map<_StrikerMotion, _KeeperAtlas> _atlases = {};

  // (file name in striker_v2/, grid cols, grid rows, cell px). Cells are
  // 640px (bumped from 512px, which itself was bumped from the keeper's
  // 256px) — the striker sits much closer to the camera (world z ≈ -0.25
  // vs the keeper's z ≈ 22.3), so the same projected.scale factor renders
  // him roughly 3x larger on screen. Even at 512px, thin high-frequency
  // silhouette detail (hanging arm, fingers) still visibly softened under
  // FilterQuality.high bicubic upscaling on high-DPI devices, which read
  // as "the sprite is transparent" rather than "it's blurry".
  // 4th element is the REAL frame count, which can be less than cols*rows
  // when the grid pads out to a GPU-safe shape — using the raw cell count
  // instead lets `_drawAtlasFrame`'s progress mapping land on a blank
  // padding cell, making the sprite flicker/vanish.
  //
  // Re-baked from the "5th iteration 30fps" mocap render (`Kicker ILDE` +
  // `Kicker shoot`, absolute frames 42-65 and 186-221 of the same
  // `Transition_003` take) — one continuous, fixed-camera capture, so all
  // four atlases share scale/anchor without per-motion alignment. Ball
  // contact identified by eye at frame 206; kick window is 205-212 padded
  // to 8 cells. idle (24 real) loops cleanly frame-to-frame (0042 ~= 0065).
  static const Map<_StrikerMotion, (String, int, int, int)> _atlasSpecs = {
    _StrikerMotion.idle: ('striker_idle.png', 6, 4, 24),
    _StrikerMotion.windup: ('striker_windup.png', 5, 4, 20),
    _StrikerMotion.kick: ('striker_kick.png', 4, 2, 7),
    // 22 real frames: recovery (213-221) + THE SAME take's own embedded
    // idle-sway cycle (241-253) — not just "return to standing", the shot
    // was filmed with a sway cycle already baked on after it, in the same
    // continuous performance as the recovery. The 222-240 gap was never
    // exported (nothing new there), so 221->241 is a cut between two
    // near-identical standing poses, not a splice across clips. Frame 253
    // (this atlas's last real cell) lands close enough to idle's own frame
    // 0 that handing off to the separately-baked idle loop needs no
    // cross-fade — see the settle->idle handoff in render() below.
    _StrikerMotion.settle: ('striker_settle.png', 6, 4, 22),
  };

  // Phase durations for this model's own windup/kick/settle playback, paced
  // at the source footage's real 30fps speed. `PenaltyGame` launches the
  // ball on its OWN separate, shorter timer (`_ballLaunchDelay`) rather
  // than waiting for `windupSeconds` — gating on the full windup read as a
  // dead pause after the kick's fast swing-through was already done.
  static const double windupSeconds = 20 / 30;
  static const double kickSeconds = 7 / 30;
  static const double kickEndSeconds = windupSeconds + kickSeconds;
  static const double settleSeconds = 22 / 30;

  ui.Image? _ready;
  ui.Image? _windup;
  ui.Image? _kick;

  Future<void> load() async {
    await Future.wait(
      _atlasSpecs.entries.map((entry) async {
        final (file, cols, rows, _) = entry.value;
        final image = await _loadOptionalUiImage(
          'packages/mapness/assets/tifo/sprites/striker_v2/$file',
        );
        if (image != null) {
          _atlases[entry.key] = _KeeperAtlas(
            image: image,
            cellWidth: 640,
            cellHeight: 640,
            cols: cols,
            rows: rows,
          );
        }
      }),
    );
    if (_atlases.isNotEmpty) {
      return;
    }

    try {
      final sprites = await Future.wait([
        _loadUiImage('packages/mapness/assets/tifo/sprites/striker_ready.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/striker_windup.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/striker_kick.png'),
      ]);
      _ready = sprites[0];
      _windup = sprites[1];
      _kick = sprites[2];
    } catch (_) {
      // Falls through to the fully-procedural _renderFallback silhouette.
    }
  }

  void render(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 base,
    required _ShotState state,
    required double shotTime,
    required double elapsed,
    required double resultTime,
  }) {
    if (_atlases.isEmpty) {
      _renderLegacy(game, canvas, base: base, state: state, shotTime: shotTime, elapsed: elapsed);
      return;
    }

    // Settle (22 real frames: recovery + the take's own embedded idle-sway
    // cycle, see `_atlasSpecs`) is a plain camera-facing recovery, not a
    // turnaround — orientation never changes. `shotTime` freezes the
    // instant the ball resolves; `resultTime` (0 at that same instant)
    // picks up the clock from there with no jump, so this always plays the
    // full recovery once instead of freezing mid-motion.
    const settleForwardSeconds = settleSeconds;
    final settleElapsed = (shotTime - kickEndSeconds) + resultTime;

    // Every atlas is a separately-shot clip, so in principle a cut between
    // motions risks a pose mismatch. Tried alpha cross-fading the two seams
    // that land while the figure is otherwise at rest (idle->windup at the
    // moment of the tap, settle->idle once settle's done) — made it WORSE:
    // idle and windup are close but not pixel-identical poses, and alpha
    // blending two different, non-fully-overlapping silhouettes doesn't
    // produce a smooth in-between pose, it produces a literal double
    // exposure — wherever only one of the two images has coverage, that
    // region renders at whatever opacity that layer is at, i.e. genuinely
    // see-through, not blurred. That read as a translucency glitch/flicker,
    // worse than the pop it was meant to hide. Both seams are straight cuts
    // now — settle->idle because its baked-in tail already ends on an
    // idle-matching pose (see `_atlasSpecs`), idle->windup because the two
    // starting poses are already close enough that a direct cut doesn't
    // pop either.

    // Once settle's done, hand off to idle's own animated sway
    // instead of holding on settle's last frame — a static freeze while
    // waiting for `_resetRound` to flip `state` back to aiming read as the
    // striker just standing there doing nothing after the kick.
    // Also requires the ball to have actually resolved (state past `flying`,
    // not just past the 0.3s settle clock) — `settleElapsed` keeps counting
    // the whole time the ball is airborne, and a shot can fly for up to
    // ~1.5s (`_ballLaunchDelay` + flightTime) versus the striker's own
    // ~1.2s windup+kick+settle. Without this, he'd hand off to idle's
    // relaxed aiming-sway well before the ball actually lands — reading as
    // "he's already done, why is the ball still going" (the animation
    // looking like it quit early), instead of holding his post-kick stance
    // and watching until the result is known.
    final justSettled =
        state != _ShotState.aiming && state != _ShotState.flying && settleElapsed >= settleForwardSeconds;
    final showIdle = state == _ShotState.aiming || justSettled;

    // Whether the idle-only sway offset/shadow size are active — both
    // seams are now straight texture cuts (see above), so this can be a
    // plain bool instead of a faded ramp.
    final idleWeight = showIdle ? 1.0 : 0.0;

    final idleShift = math.sin(elapsed * math.pi * 0.9) * idleWeight;
    final plantedBase = _Vec3(
      base.x + idleShift * 0.035,
      base.y,
      base.z,
    );
    game._drawShadow(
      canvas,
      _Vec3(plantedBase.x - 0.05, 0, plantedBase.z + 1.25),
      0.96 - 0.1 * idleWeight,
      0.27 - 0.05 * idleWeight,
    );

    // Real subtle standing-sway loop while idling, instead of one static
    // pose with a fake breathing skew. Straight restart at frame 0 (not
    // ping-ponged) — this footage's first and last frames land on almost
    // the same pose (0042 ~= 0065), so a hard restart doesn't pop.
    const idleCycleSeconds = 24 / 30;
    double idlePhaseAt(double t) => (t % idleCycleSeconds) / idleCycleSeconds;

    if (showIdle) {
      // Straight cut, no cross-fade — whether from `aiming` (idle was
      // already playing) or from `justSettled` (settle's last baked frame
      // already matches idle's own first frame), there's no pose jump to
      // hide here.
      _drawAtlasFrame(game, canvas, motion: _StrikerMotion.idle, progress: idlePhaseAt(elapsed), base: plantedBase);
      return;
    }

    if (shotTime < windupSeconds) {
      final progress = shotTime / windupSeconds;
      _drawAtlasFrame(game, canvas, motion: _StrikerMotion.windup, progress: progress, base: plantedBase);
      return;
    }

    if (shotTime < kickEndSeconds) {
      _drawAtlasFrame(
        game,
        canvas,
        motion: _StrikerMotion.kick,
        progress: (shotTime - windupSeconds) / kickSeconds,
        base: plantedBase,
      );
      return;
    }

    // Linear, NOT eased — settle is real 30fps mocap footage (9 frames),
    // so the frame timing IS the real motion already. `_easeOutCubic` here
    // front-loaded progress so hard that the discrete frame index (rounded)
    // hit the last real frame around 60% into the window and then just
    // held there — the leg visibly stops moving, then a beat later the
    // idle crossfade kicks in, reading as "freeze, then a jump-cut" instead
    // of one continuous motion.
    final progress = (settleElapsed / settleForwardSeconds).clamp(0.0, 1.0);
    _drawAtlasFrame(game, canvas, motion: _StrikerMotion.settle, progress: progress, base: plantedBase);
  }

  /// Foot-anchored draw of one atlas cell — `progress` (0..1) picks the
  /// frame within that motion's own atlas (native frame count, varies per
  /// motion — see _atlasSpecs).
  void _drawAtlasFrame(
    PenaltyGame game,
    Canvas canvas, {
    required _StrikerMotion motion,
    required double progress,
    required _Vec3 base,
    double opacity = 1,
  }) {
    if (opacity <= 0) {
      return;
    }
    final atlas = _atlases[motion];
    if (atlas == null) {
      return;
    }
    final projected = game._project(base);
    if (projected == null) {
      return;
    }
    // Real frame count, NOT atlas.cols * atlas.rows — some grids (settle)
    // pad out with blank cells to stay inside the GPU texture limit; see
    // _atlasSpecs.
    final total = _atlasSpecs[motion]!.$4;
    final frame = (progress.clamp(0.0, 1.0) * (total - 1)).round();
    final sourceRect = atlas.cellRect(frame);
    // Cells are baked square with generous padding around the figure — see
    // the bake script notes. 3.9 keeps the on-screen figure size matching
    // the old tightly-cropped single-pose sprites (measured compensation:
    // old sprites were ~93% figure-fill vs ~80% for the new square cells).
    const worldHeight = 3.9;
    final height = math.max(70.0, projected.scale * worldHeight);
    final dst = Rect.fromLTWH(
      projected.offset.dx - height / 2,
      projected.offset.dy - height,
      height,
      height,
    );
    canvas.drawImageRect(atlas.image, sourceRect, dst, _spritePaint(opacity));
  }

  /// Legacy single-pose-plus-procedural-skew rig — only reached if none of
  /// the per-motion atlases in `striker_v2/` load.
  void _renderLegacy(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 base,
    required _ShotState state,
    required double shotTime,
    required double elapsed,
  }) {
    final ready = _ready;
    final windup = _windup;
    final kick = _kick;
    if (ready == null || windup == null || kick == null) {
      _renderFallback(game, canvas, base, state, shotTime);
      return;
    }

    final isAiming = state == _ShotState.aiming;
    final idleBreath = math.sin(elapsed * math.pi * 1.55);
    final idleShift = math.sin(elapsed * math.pi * 0.9);
    final plantedBase = _Vec3(
      base.x + (isAiming ? idleShift * 0.035 : 0),
      base.y,
      base.z,
    );
    game._drawShadow(
      canvas,
      _Vec3(plantedBase.x - 0.05, 0, plantedBase.z + 0.1),
      isAiming ? 0.86 : 0.96,
      isAiming ? 0.22 : 0.27,
    );

    if (isAiming) {
      _drawFrame(
        game,
        canvas,
        image: ready,
        base: plantedBase,
        worldHeight: 3.35,
        anchorX: 0.58,
        rotation: idleShift * 0.018,
        scaleX: 1 - idleBreath * 0.006,
        scaleY: 1 + idleBreath * 0.014,
      );
      return;
    }

    if (shotTime < 0.1) {
      final t = _smoothStep(shotTime / 0.1);
      _drawFrame(
        game,
        canvas,
        image: windup,
        base: _Vec3(
          plantedBase.x - 0.05 - 0.08 * t,
          0,
          plantedBase.z + 0.02 * t,
        ),
        worldHeight: 3.42,
        anchorX: 0.46,
        rotation: -0.035 * t,
        scaleX: 1 + t * 0.025,
        scaleY: 1 - t * 0.012,
      );
      return;
    }

    if (shotTime < 0.24) {
      final t = _smoothStep((shotTime - 0.1) / 0.14);
      _drawFrame(
        game,
        canvas,
        image: kick,
        base: _Vec3(plantedBase.x + 0.02 * t, 0, plantedBase.z + 0.07 * t),
        worldHeight: 3.5,
        anchorX: 0.5,
        rotation: 0.055 * t,
        scaleX: 1 + 0.035 * t,
        screenOffset: Offset(0, -10 * t),
      );
      return;
    }

    final settle = _easeOutCubic(((shotTime - 0.24) / 0.7).clamp(0, 1));
    _drawFrame(
      game,
      canvas,
      image: kick,
      base: _Vec3(plantedBase.x + 0.04 * (1 - settle), 0, plantedBase.z + 0.08),
      worldHeight: 3.5,
      anchorX: 0.5,
      rotation: 0.06 * (1 - settle * 0.55),
      scaleX: 1.03 - settle * 0.015,
      scaleY: 1.02 - settle * 0.01,
      screenOffset: Offset(0, -10 * (1 - settle)),
    );
  }

  void _drawFrame(
    PenaltyGame game,
    Canvas canvas, {
    required ui.Image image,
    required _Vec3 base,
    required double worldHeight,
    required double anchorX,
    double opacity = 1,
    double rotation = 0,
    double scaleX = 1,
    double scaleY = 1,
    Offset screenOffset = Offset.zero,
  }) {
    if (opacity <= 0.01) {
      return;
    }
    final projected = game._project(base);
    if (projected == null) {
      return;
    }
    final height = math.max(70.0, projected.scale * worldHeight * scaleY);
    final width = height * image.width / image.height * scaleX;
    final anchor = projected.offset + screenOffset;
    final dst = Rect.fromLTWH(
      anchor.dx - width * anchorX,
      anchor.dy - height,
      width,
      height,
    );

    canvas.save();
    canvas.translate(anchor.dx, anchor.dy);
    canvas.rotate(rotation);
    canvas.translate(-anchor.dx, -anchor.dy);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      dst,
      _spritePaint(opacity),
    );
    canvas.restore();
  }

  void _renderFallback(
    PenaltyGame game,
    Canvas canvas,
    _Vec3 base,
    _ShotState state,
    double shotTime,
  ) {
    final kick = state == _ShotState.flying ? (1 - (shotTime / 0.32)).clamp(0.0, 1.0).toDouble() : 0.0;
    game._drawWorldLine(
      canvas,
      _Vec3(base.x - 0.27, 0.9, base.z - 0.75),
      _Vec3(base.x + 0.2 + kick * 0.22, 0.35, base.z - 0.02 + kick * 0.38),
      const Color(0xFF16243C),
      0.18,
    );
    game._drawBox(
      canvas,
      _Vec3(base.x + 0.4 + kick * 0.24, 0.18, base.z + 0.18 + kick * 0.54),
      _Vec3(0.72, 0.2, 0.36),
      const Color(0xFF151515),
    );
  }
}

class _GoalkeeperModel {
  // Measured directly off the re-baked `keeper_idle.png`: the character's
  // feet sit this fraction of a cell's height short of the cell's bottom
  // edge (the shared idle/ready/dive crop box is sized for the widest
  // pose — a flat-out dive — so standing poses don't fill it edge-to-edge
  // the way the dive atlases do). See `_drawIdleSprite`'s `groundGap`.
  static const double _standingGroundGap = 0.15625;

  ui.Image? _idleSprite;
  ui.Image? _diveMidLeftSprite;
  ui.Image? _diveLowLeftSprite;
  ui.Image? _diveHighLeftSprite;
  _SpriteSheet? _readySheet;
  _SpriteSheet? _diveMidLeftSheet;
  _SpriteSheet? _diveLowLeftSheet;
  _SpriteSheet? _diveHighLeftSheet;
  // Result-phase sheets — kick in after the dive peak.
  _SpriteSheet? _missedReactionSheet;
  _SpriteSheet? _concededSheet;
  // Preferred path: one small atlas PER MOTION (native frame density, up to
  // 24 frames each — see the bake script in project notes), superseding the
  // legacy per-motion sheets above wherever a motion's atlas loaded OK.
  // Each motion gets its own image/grid because their real available frame
  // counts differ a lot (8 for `ready`, up to 24 for the longer clips) —
  // a single shared atlas can't give every row its own natural length
  // without wasting cells or blowing past safe GPU texture dimensions.
  final Map<_KeeperMotion, _KeeperAtlas> _atlases = {};

  // (file name in goalkeeper_v2/, grid cols, grid rows). Grid shape just
  // packs that motion's native frame count into a compact grid — frame
  // order is row-major through the grid, independent of shape.
  // 4th element is the REAL frame count — normally cols*rows, but grids are
  // sized to fit exactly wherever possible (see below) so this is usually
  // equal to cols*rows now.
  //
  // Re-baked from the "5th iteration 30fps" mocap render (GSP_8638tris
  // clips, real 30fps, same set the striker used): `GSP_crouch_moving_right`
  // (idle, whole 61-frame loop — frame 0 ~= frame 60), `GSP_save_lower_right`
  // frames 0-59 (diveLowRight: plant+launch+land) and 60-120 (groundRight:
  // flat-on-ground -> recover -> stand), `GSP_save_lower_center` (whole
  // 73-frame clip — self-contained reach+recover, same trick as the
  // striker's settle), `GSP_save_upper_center` (whole 71-frame clip, same
  // reasoning), `GSP_save_upper_right` frames 0-49 (diveUpRight: launch+land
  // only — shares `groundRight` for recovery instead of baking a second
  // near-identical one). `diveLowLeft`/`groundLeft` are horizontally
  // mirrored bakes of the `...Right` atlases (no dedicated left-side render
  // existed in this batch); `diveUpLeft` still mirrors `diveUpRight` at
  // DRAW time (see `_diveMotionFor`/`needsFlip`), unchanged.
  //
  // All seven re-baked atlases share ONE crop box (computed as the union
  // bounding box across every source frame used, +5% padding) instead of
  // each being cropped to its own tightest fit — the pose range here spans
  // standing idle to a fully horizontal flat-out dive, and fitting each
  // atlas to its own bounds would make the character visibly change size
  // between motions. `ready` has no dedicated capture, so it reuses a
  // sparse sample of the same crouch clip as idle (visually
  // near-identical, which is fine for a sub-quarter-second transition).
  static const Map<_KeeperMotion, (String, int, int, int)> _atlasSpecs = {
    _KeeperMotion.idle: ('keeper_idle.png', 8, 8, 61),
    _KeeperMotion.ready: ('keeper_ready.png', 4, 2, 8),
    _KeeperMotion.diveLowLeft: ('keeper_diveLowLeft.png', 6, 10, 60),
    _KeeperMotion.diveLowRight: ('keeper_diveLowRight.png', 6, 10, 60),
    _KeeperMotion.diveLowCenter: ('keeper_diveLowCenter.png', 8, 10, 73),
    _KeeperMotion.diveUpCenter: ('keeper_diveUpCenter.png', 8, 9, 71),
    _KeeperMotion.diveUpRight: ('keeper_diveUpRight.png', 5, 10, 50),
    _KeeperMotion.groundLeft: ('keeper_groundLeft.png', 8, 8, 61),
    _KeeperMotion.groundRight: ('keeper_groundRight.png', 8, 8, 61),
  };

  /// Dive motion for a given height/side combo. Upper-left has no native
  /// render — it reuses [_KeeperMotion.diveUpRight] mirrored (see the
  /// `needsFlip` check in `_renderSprite`, which duplicates this same
  /// style==high && side==left condition to drive the canvas flip).
  static _KeeperMotion _diveMotionFor(_KeeperDive style, _KeeperSide side) {
    if (style == _KeeperDive.high) {
      return switch (side) {
        _KeeperSide.center => _KeeperMotion.diveUpCenter,
        _KeeperSide.right || _KeeperSide.left => _KeeperMotion.diveUpRight,
      };
    }
    return switch (side) {
      _KeeperSide.center => _KeeperMotion.diveLowCenter,
      _KeeperSide.right => _KeeperMotion.diveLowRight,
      _KeeperSide.left => _KeeperMotion.diveLowLeft,
    };
  }

  Color _jersey = const Color(0xFFFFA726);
  Color _shorts = const Color(0xFF223A5E);
  Color _skin = const Color(0xFFF1BE91);
  Color _sock = const Color(0xFFE9F0F7);
  Color _glove = const Color(0xFFF7F7F2);
  Color _boot = const Color(0xFF111318);
  Color _hair = const Color(0xFF3A2417);
  int _sourceModelBytes = 0;
  _GlbModel? _sourceModel;

  Future<void> load() async {
    try {
      final sprites = await Future.wait([
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_idle.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_left.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_low_left.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_high_left.png'),
      ]);
      _idleSprite = sprites[0];
      _diveMidLeftSprite = sprites[1];
      _diveLowLeftSprite = sprites[2];
      _diveHighLeftSprite = sprites[3];
      // Preferred source — one small atlas per motion (see _atlasSpecs).
      await Future.wait(
        _atlasSpecs.entries.map((entry) async {
          final (file, cols, rows, _) = entry.value;

          final image = await _loadOptionalUiImage(
            'packages/mapness/assets/tifo/sprites/goalkeeper_v2/$file',
          );

          if (image != null) {
            final reverseColumns = switch (entry.key) {
              _KeeperMotion.diveLowLeft || _KeeperMotion.groundLeft => true,
              _ => false,
            };

            _atlases[entry.key] = _KeeperAtlas(
              image: image,
              cellWidth: 256,
              cellHeight: 256,
              cols: cols,
              rows: rows,
              reverseColumns: reverseColumns,
            );
          }
        }),
      );
      // Legacy per-motion sheets — fallback if the atlas asset is missing.
      _readySheet = await _loadOptionalSheet(
        'packages/mapness/assets/tifo/sprites/goalkeeper_v2/ready_sheet.png',
        frameWidth: 384,
        frameHeight: 384,
        frames: 10,
      );
      _diveMidLeftSheet = await _loadOptionalSheet(
        'packages/mapness/assets/tifo/sprites/goalkeeper_v2/dive_mid_left_sheet.png',
        frameWidth: 384,
        frameHeight: 384,
        frames: 10,
      );
      _diveLowLeftSheet = await _loadOptionalSheet(
        'packages/mapness/assets/tifo/sprites/goalkeeper_v2/dive_low_left_sheet.png',
        frameWidth: 384,
        frameHeight: 384,
        frames: 10,
      );
      _diveHighLeftSheet = await _loadOptionalSheet(
        'packages/mapness/assets/tifo/sprites/goalkeeper_v2/dive_high_left_sheet.png',
        frameWidth: 384,
        frameHeight: 384,
        frames: 10,
      );
      _missedReactionSheet = await _loadOptionalSheet(
        'packages/mapness/assets/tifo/sprites/goalkeeper_v2/missed_reaction_sheet.png',
        frameWidth: 384,
        frameHeight: 384,
        frames: 8,
      );
      _concededSheet = await _loadOptionalSheet(
        'packages/mapness/assets/tifo/sprites/goalkeeper_v2/conceded_sheet.png',
        frameWidth: 384,
        frameHeight: 384,
        frames: 8,
      );
      return;
    } catch (_) {
      // Keep the procedural/GLB path as a fallback if project sprites are absent.
    }

    final raw = await rootBundle.loadString(
      'packages/mapness/assets/tifo/models/goalkeeper.model.json',
    );
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final sourceAsset = data['sourceAsset'] as String? ?? '';
    if (sourceAsset.isNotEmpty) {
      final glbData = await rootBundle.load(sourceAsset);
      _sourceModelBytes = glbData.lengthInBytes;
      _sourceModel = _GlbModel.parse(glbData);
    }
    final palette = data['palette'] as Map<String, dynamic>? ?? {};
    _jersey = _colorFromHex(palette['jersey'] as String? ?? '#FFA726');
    _shorts = _colorFromHex(palette['shorts'] as String? ?? '#223A5E');
    _skin = _colorFromHex(palette['skin'] as String? ?? '#F1BE91');
    _sock = _colorFromHex(palette['socks'] as String? ?? '#E9F0F7');
    _glove = _colorFromHex(palette['gloves'] as String? ?? '#F7F7F2');
    _boot = _colorFromHex(palette['boots'] as String? ?? '#111318');
    _hair = _colorFromHex(palette['hair'] as String? ?? '#3A2417');
  }

  void render(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 base,
    required double dive,
    required double lift,
    required double actionTime,
    required _KeeperDive diveStyle,
    _KeeperSide diveSide = _KeeperSide.center,
    bool reacting = false,
    double visualScale = 1,
    _ShotState? shotState,
    double resultTime = 0,
  }) {
    final idleSprite = _idleSprite;
    final diveMidLeftSprite = _diveMidLeftSprite;
    if (idleSprite != null && diveMidLeftSprite != null) {
      _renderSprite(
        game,
        canvas,
        base: base,
        dive: dive,
        lift: lift,
        actionTime: actionTime,
        diveStyle: diveStyle,
        diveSide: diveSide,
        reacting: reacting,
        visualScale: visualScale,
        idleSprite: idleSprite,
        diveMidLeftSprite: diveMidLeftSprite,
        diveLowLeftSprite: _diveLowLeftSprite,
        diveHighLeftSprite: _diveHighLeftSprite,
        shotState: shotState,
        resultTime: resultTime,
      );
      return;
    }

    final action = (lift / 0.24).clamp(0.0, 1.0).toDouble();
    final lean = dive * action;
    final x = base.x + lean * 0.28;
    final z = base.z;
    final modelScale = _sourceModelBytes > 0 ? 1.0 : 0.94;

    game._drawShadow(
      canvas,
      _Vec3(x + lean * 0.32, 0, z),
      1.05 * modelScale,
      0.28,
    );

    final sourceModel = _sourceModel;
    if (sourceModel != null) {
      sourceModel.render(
        game,
        canvas,
        origin: _Vec3(x - 0.04, 0.02 + lift, z),
        scale: 1.28 * modelScale,
        yaw: lean * 0.18,
        roll: -lean * 0.16,
        tint: _jersey,
      );
      _drawArms(game, canvas, x, z, lift, lean);
      _drawHead(game, canvas, x + lean * 0.16, z - 0.04, lift, lean);
      return;
    }

    _drawLegs(game, canvas, x, z, lift, lean);
    game._drawBox(
      canvas,
      _Vec3(x - lean * 0.06, 0.72 + lift, z),
      _Vec3(0.74, 0.28, 0.32),
      _shorts,
    );
    game._drawJerseyTorso(
      canvas,
      _Vec3(x, 1.13 + lift, z - 0.03),
      lean,
      _jersey,
    );
    _drawArms(game, canvas, x, z, lift, lean);
    _drawHead(game, canvas, x + lean * 0.16, z - 0.04, lift, lean);
  }

  void _renderSprite(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 base,
    required double dive,
    required double lift,
    required double actionTime,
    required _KeeperDive diveStyle,
    required _KeeperSide diveSide,
    required bool reacting,
    required double visualScale,
    required ui.Image idleSprite,
    required ui.Image diveMidLeftSprite,
    required ui.Image? diveLowLeftSprite,
    required ui.Image? diveHighLeftSprite,
    _ShotState? shotState,
    double resultTime = 0,
  }) {
    // `dive` still positions the sprite along the dive trajectory, but the
    // reaction gate is the explicit [reacting] flag — a pure center dive has
    // direction 0 and would otherwise read as "idle".
    final direction = dive.signOrZero;
    // Flip only for upper-left: every other side has a native render. This
    // is purely a mirror-the-image flag — it must NOT affect positioning
    // (world-space left/right still comes from the real `direction`).
    final needsFlip = diveStyle == _KeeperDive.high && diveSide == _KeeperSide.left;
    // Was a flat 0.54s (ready+launch). At that speed a shot that resolved
    // quickly (most of them — see below) squeezed the whole ~2s of real
    // dive footage into ~0.39s of screen time, a ~5x speedup: the rotation
    // through the air (a real physical body turning) flickered through so
    // many distinct poses per real second that it read as the keeper's
    // depth "pulsing" nearer/farther, on top of just looking like a jump-
    // cut rather than a dive. 1.0s roughly halves that compression.
    //
    // `actionTime` (passed in) freezes the instant the ball resolves —
    // it's derived from `_ballFlightElapsed`, which stops advancing once
    // `_state` leaves `flying`, same mechanism as the striker's
    // `_shotTime`. A fast shot resolves at `actionTime` ~= 0.5-0.6s
    // regardless of power (`flightTime * 0.6`, see `_shootAtTarget`) —
    // well short of the new 1.0s window — so without `resultTime` folded
    // in here too, raising the window would freeze the launch HALF
    // THROUGH and cut straight to celebrate/ground (branch 1 below),
    // making the keeper look like he teleported through the rest of his
    // dive. Adding `resultTime` (0 at that same freeze instant) picks the
    // clock back up with no jump, exactly like the striker's
    // `settleElapsed` — the launch always finishes playing before we hand
    // off to the result motion (see `diveFullyPlayed`/`resultOverhang`).
    const diveWindowSeconds = 1.0;
    final diveElapsed = actionTime + resultTime;
    final diveProgress = (diveElapsed / diveWindowSeconds).clamp(0.0, 1.0).toDouble();
    final diveFullyPlayed = diveProgress >= 1.0;

    // A shot placed dead-center never sends the keeper anywhere — he plants
    // and stays put. No prep lean, no dive, no fall to recover from.
    final isCenter = diveSide == _KeeperSide.center;

    // 1. Result phase — once `_finish` has flipped `shotState` to a terminal
    //    outcome (save, miss, or goal — no separate celebration anymore,
    //    all three just play the same slide-and-rise recovery), play the
    //    recovery motion. Gated on `diveFullyPlayed` (always true for
    //    center, which never launches a dive) so a fast shot can't cut the
    //    launch short — see the comment on `diveWindowSeconds` above.
    final groundMotion = diveSide == _KeeperSide.right ? _KeeperMotion.groundRight : _KeeperMotion.groundLeft;
    final resultMotion = switch (shotState) {
      // A center shot leaves the keeper standing — there's no lying/
      // kneeling pose to recover from, so it just holds his ground (falls
      // through to the idle branch below) instead of playing the
      // dive-recovery clip.
      _ShotState.saved || _ShotState.missed || _ShotState.goal => isCenter ? null : groundMotion,
      _ => null,
    };
    if (resultMotion != null && reacting && (isCenter || diveFullyPlayed)) {
      // How much of `resultTime` went into finishing the launch (0 if it
      // had already fully played by the time the ball resolved) — the
      // result motion's OWN 0.75s reaction clock starts only after that,
      // so it doesn't visually fast-forward to catch up.
      final resultOverhang = isCenter ? 0.0 : math.max(0.0, diveWindowSeconds - actionTime);
      // 0.75s for the reaction; the result HUD lives ~1.65s so the keeper
      // holds the final frame for the remainder.
      final resultProgress = ((resultTime - resultOverhang) / 0.75).clamp(0.0, 1.0).toDouble();
      final pose = _motionPose(
        resultMotion,
        resultProgress,
        fallback: diveMidLeftSprite,
      );
      // Foot-anchored, not center-anchored: groundLeft/groundRight are
      // baked bottom-aligned (feet at the cell's bottom edge) because by
      // this point the keeper is grounded, not mid-flight. Using
      // _drawDivingSprite's center-anchor here (as before) put the world
      // anchor at the character's hip instead of their feet, sinking the
      // sprite visibly below the pitch.
      //
      // groundLeft/Right share idle's re-baked crop (see
      // `_standingGroundGap`), or standing back up reads as levitating
      // just above the shadow.
      _drawIdleSprite(
        game,
        canvas,
        base: base,
        lift: 0,
        image: pose.$1,
        sourceRect: pose.$2,
        visualScale: visualScale,
        groundGap: _standingGroundGap,
      );
      return;
    }

    // 2. Crouch/prep phase — keeper plants and leans toward dive target.
    //    Skipped for center: he has nowhere to lean toward.
    if (!isCenter && reacting && diveProgress > 0.08 && diveProgress < 0.28) {
      final prep = _smoothStep((diveProgress - 0.08) / 0.2);
      final pose = _motionPose(_KeeperMotion.ready, prep, fallback: idleSprite);
      _drawIdleSprite(
        game,
        canvas,
        base: _Vec3(base.x + direction * prep * 0.16, base.y, base.z),
        lift: lift * 0.2,
        image: pose.$1,
        sourceRect: pose.$2,
        visualScale: visualScale,
        lean: direction * prep,
        crouch: prep,
        groundGap: _standingGroundGap,
      );
      return;
    }

    // 3. Dive launch — native left/right animation per side. Center never
    //    reaches here — he holds his idle stance through the whole shot
    //    (phase 4 below) since the ball is coming straight at him.
    if (!isCenter && reacting && diveProgress >= 0.28) {
      final motion = _diveMotionFor(diveStyle, diveSide);
      final fallbackSprite = switch (diveStyle) {
        _KeeperDive.low => diveLowLeftSprite ?? diveMidLeftSprite,
        _KeeperDive.mid => diveMidLeftSprite,
        _KeeperDive.high => diveHighLeftSprite ?? diveMidLeftSprite,
      };
      // `launch` (eased) drives the physical lunge — legitimately fast-out/
      // slow-in, like a real dive. But using that SAME eased value to pick
      // which of the up to 24 real photographed frames to show front-loads
      // the pose changes: most of the rotation from standing to horizontal
      // blows through in the first sliver of the window (reading as "shrinks
      // and spins"), then the last frame holds for the rest of it. Frame
      // selection instead advances at a constant rate across the window —
      // same total dive duration/hit-detection timing, just an even flip
      // through the photographed poses instead of a front-loaded one.
      final diveT = ((diveProgress - 0.28) / 0.72).clamp(0.0, 1.0);
      final launch = _easeOutCubic(diveT);
      final pose = _motionPose(motion, diveT, fallback: fallbackSprite);
      _drawDivingSprite(
        game,
        canvas,
        base: base,
        direction: direction,
        lift: lift,
        progress: launch,
        image: pose.$1,
        sourceRect: pose.$2,
        visualScale: visualScale,
        diveStyle: diveStyle,
        flip: needsFlip,
      );
      return;
    }

    // 4. Idle cycle — crouch-sway loop while waiting for the shot, paced at
    // the source footage's real 30fps speed (61 real frames / ~2.03s per
    // full loop) instead of the previous arbitrary "7 steps/sec", which
    // didn't correspond to any real timing and (via `cols*rows`, 64) could
    // also land on a padded/duplicate cell instead of a real frame.
    final idleAtlas = _atlases[_KeeperMotion.idle];
    final idleRealFrames = idleAtlas != null ? _atlasSpecs[_KeeperMotion.idle]!.$4 : (_readySheet?.frames ?? 0);
    const idleFps = 30.0;
    final idleCycleSeconds = idleRealFrames / idleFps;
    final idleCycle = idleCycleSeconds > 0 ? (game._elapsed % idleCycleSeconds) / idleCycleSeconds : null;
    if (idleCycle != null) {
      final pose = _motionPose(_KeeperMotion.idle, idleCycle, fallback: idleSprite);
      _drawIdleSprite(
        game,
        canvas,
        base: base,
        lift: lift,
        image: pose.$1,
        sourceRect: pose.$2,
        visualScale: visualScale,
        groundGap: _standingGroundGap,
      );
    } else {
      _drawIdleSprite(
        game,
        canvas,
        base: base,
        lift: lift,
        image: idleSprite,
        visualScale: visualScale,
      );
    }
  }

  /// Look up `(image, sourceRect)` for a logical motion at the given progress.
  /// Prefers that motion's own atlas; falls back to the legacy per-motion
  /// sheet, and finally to the static single-pose [fallback].
  (ui.Image, Rect?) _motionPose(
    _KeeperMotion motion,
    double progress, {
    required ui.Image fallback,
  }) {
    final atlas = _atlases[motion];
    if (atlas != null) {
      // Real frame count, NOT atlas.cols * atlas.rows — see _atlasSpecs.
      final total = _atlasSpecs[motion]!.$4;
      final idx = (progress.clamp(0.0, 1.0) * (total - 1)).floor();
      // if (motion == _KeeperMotion.diveLowLeft) {
      //   debugPrint(
      //     'progress=${progress.toStringAsFixed(3)} '
      //     'idx=$idx total=$total',
      //   );
      // }
      return (atlas.image, atlas.cellRect(idx));
    }
    final sheet = switch (motion) {
      _KeeperMotion.idle || _KeeperMotion.ready => _readySheet,
      _KeeperMotion.diveLowLeft ||
      _KeeperMotion.diveLowRight ||
      _KeeperMotion.diveLowCenter => _diveLowLeftSheet ?? _diveMidLeftSheet,
      _KeeperMotion.diveUpCenter || _KeeperMotion.diveUpRight => _diveHighLeftSheet ?? _diveMidLeftSheet,
      _KeeperMotion.groundLeft || _KeeperMotion.groundRight => _missedReactionSheet ?? _concededSheet,
    };
    if (sheet != null) {
      return (sheet.image, _sheetFrame(sheet, progress));
    }
    return (fallback, null);
  }

  Rect? _sheetFrame(_SpriteSheet? sheet, double progress) {
    if (sheet == null) {
      return null;
    }
    final frame = (progress.clamp(0.0, 1.0) * (sheet.frames - 1)).round();
    return sheet.frameRect(frame);
  }

  void _drawIdleSprite(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 base,
    required double lift,
    required ui.Image image,
    Rect? sourceRect,
    double visualScale = 1,
    double lean = 0,
    double crouch = 0,
    // Fraction of the drawn height that is transparent padding BELOW the
    // character's feet within the source cell — 0 assumes feet sit exactly
    // on the cell's bottom edge (true for the old hand-cropped sheets).
    // The re-baked idle/ready atlas shares one crop box with the dive
    // atlases (needed so scale stays consistent between standing and a
    // flat-out horizontal dive — see `_atlasSpecs`), and idle's own feet
    // land well short of that shared crop's bottom edge (~15.6% of the
    // cell). Anchoring the cell's bottom edge to the ground point like
    // before then floats the actual feet that same fraction above the
    // ground/shadow. This shifts the draw down to compensate.
    double groundGap = 0,
  }) {
    final foot = game._project(_Vec3(base.x + lean * 0.04, 0, base.z));
    if (foot == null) {
      return;
    }
    final breath = math.sin(game._elapsed * math.pi * 1.7);
    final weightShift = math.sin(game._elapsed * math.pi * 0.84);
    game._drawShadow(
      canvas,
      _Vec3(base.x + lean * 0.08, 0, base.z),
      (1.12 + crouch * 0.1) * visualScale,
      0.34,
    );

    final height = math.max(
      40.0,
      foot.scale * (2.75 + lift * 0.25) * visualScale * (1 + breath * 0.012 - crouch * 0.055),
    );
    final source = sourceRect ?? Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final width = height * source.width / source.height * (1 - breath * 0.006 + crouch * 0.05);
    final bottom =
        foot.offset + Offset(weightShift * 1.8 + lean * foot.scale * 0.035, height * 0.015 + height * groundGap);
    final dst = Rect.fromLTWH(
      bottom.dx - width / 2,
      bottom.dy - height,
      width,
      height,
    );
    canvas.save();
    canvas.translate(bottom.dx, bottom.dy);
    canvas.rotate(lean * 0.035 + weightShift * 0.006);
    canvas.translate(-bottom.dx, -bottom.dy);
    canvas.drawImageRect(image, source, dst, _spritePaint());
    canvas.restore();
  }

  void _drawDivingSprite(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 base,
    required double direction,
    required double lift,
    required double progress,
    required ui.Image image,
    required _KeeperDive diveStyle,
    Rect? sourceRect,
    double visualScale = 1,
    bool flip = false,
  }) {
    final launch = progress.clamp(0.0, 1.0).toDouble();
    final baseHeight = switch (diveStyle) {
      _KeeperDive.low => 1.36,
      _KeeperDive.mid => 0.92,
      _KeeperDive.high => 1.36,
    };
    final liftBoost = switch (diveStyle) {
      _KeeperDive.low => 0.18,
      _KeeperDive.mid => 0.18,
      _KeeperDive.high => 0.34,
    };
    // Calibrated against `_drawIdleSprite`'s standing-height factor (2.75,
    // knocked down ~5.5% by the crouch term at prep's end — net ~2.6) so
    // the keeper doesn't visibly shrink at the exact moment ready hands off
    // to the dive launch. The previous values (2.15/1.85/1.95) assumed the
    // dive atlas's figures filled their cells edge-to-edge with no
    // whitespace — true for the old AI-generated 8x3 atlas, but the
    // re-baked one shares idle's crop box (padded for the widest pose, a
    // flat-out dive) and has similar headroom, so that assumption no
    // longer holds.
    final widthBase = switch (diveStyle) {
      _KeeperDive.low => 2.25,
      _KeeperDive.mid => 2.25,
      _KeeperDive.high => 2.35,
    };
    final projected = game._project(
      _Vec3(
        base.x + direction * (0.38 + launch * 0.6),
        baseHeight + lift * 0.7 + math.sin(launch * math.pi) * liftBoost,
        base.z - 0.12,
      ),
    );
    if (projected == null) {
      return;
    }
    game._drawShadow(
      canvas,
      _Vec3(base.x + direction * (0.45 + launch * 0.32), 0, base.z),
      (1.28 + launch * 0.32) * visualScale,
      0.3 - launch * 0.05,
    );

    final width = math.max(
      72.0,
      projected.scale * (widthBase + launch * 0.28) * visualScale,
    );
    final source = sourceRect ?? Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final height = width * source.height / source.width;
    final dst = Rect.fromCenter(
      center: projected.offset,
      width: width,
      height: height,
    );

    canvas.save();
    if (flip) {
      canvas.translate(dst.center.dx, dst.center.dy);
      canvas.scale(-1, 1);
      canvas.translate(-dst.center.dx, -dst.center.dy);
    }
    canvas.translate(dst.center.dx, dst.center.dy);
    canvas.rotate(-direction * 0.05 * (1 - launch));
    canvas.translate(-dst.center.dx, -dst.center.dy);
    canvas.drawImageRect(image, source, dst, _spritePaint());
    canvas.restore();
  }

  void _drawLegs(
    PenaltyGame game,
    Canvas canvas,
    double x,
    double z,
    double lift,
    double lean,
  ) {
    for (final side in [-1.0, 1.0]) {
      final hip = _Vec3(x + side * 0.22 - lean * 0.08, 0.67 + lift, z);
      final knee = _Vec3(
        x + side * 0.34 - lean * 0.18,
        0.36 + lift * 0.55,
        z - 0.02,
      );
      final ankle = _Vec3(
        x + side * 0.52 - lean * 0.32,
        0.08 + lift * 0.2,
        z + 0.03,
      );
      final boot = _Vec3(
        x + side * 0.66 - lean * 0.42,
        0.02 + lift * 0.14,
        z - 0.07,
      );

      game._drawCapsule(canvas, hip, knee, 0.095, _shorts);
      game._drawCapsule(canvas, knee, ankle, 0.075, _sock);
      game._drawBox(canvas, boot, _Vec3(0.38, 0.1, 0.18), _boot);
    }
  }

  void _drawArms(
    PenaltyGame game,
    Canvas canvas,
    double x,
    double z,
    double lift,
    double lean,
  ) {
    final reach = lean * 0.72;
    for (final side in [-1.0, 1.0]) {
      final shoulder = _Vec3(
        x + side * 0.5 + lean * 0.06,
        1.42 + lift,
        z - 0.03,
      );
      final elbow = _Vec3(
        x + side * 0.82 + reach * 0.58,
        1.22 + lift + lean.abs() * 0.15,
        z - 0.07,
      );
      final hand = _Vec3(
        x + side * 1.12 + reach * 1.05,
        1.13 + lift + lean.abs() * 0.32,
        z - 0.12,
      );

      game._drawCapsule(
        canvas,
        shoulder,
        elbow,
        0.085,
        _lighten(_jersey, 0.04),
      );
      game._drawCapsule(canvas, elbow, hand, 0.065, _skin);
      game._drawWorldSphere(canvas, hand, 0.16, _glove);
      game._drawWorldLine(
        canvas,
        _Vec3(hand.x - side * 0.11, hand.y, hand.z - 0.04),
        _Vec3(hand.x + side * 0.12, hand.y + 0.02, hand.z - 0.04),
        const Color(0xFF2D4F85),
        0.018,
      );
    }
  }

  void _drawHead(
    PenaltyGame game,
    Canvas canvas,
    double x,
    double z,
    double lift,
    double lean,
  ) {
    final head = _Vec3(x, 1.78 + lift, z - 0.08);
    game._drawWorldSphere(canvas, head, 0.24, _skin);
    game._drawWorldOval(
      canvas,
      _Vec3(x - lean * 0.02, 1.9 + lift, z - 0.1),
      0.42,
      0.18,
      _hair,
      tilt: lean * 0.18,
    );
    game._drawWorldSphere(
      canvas,
      _Vec3(x - 0.075, 1.79 + lift, z - 0.28),
      0.025,
      const Color(0xFF1D1714),
    );
    game._drawWorldSphere(
      canvas,
      _Vec3(x + 0.075, 1.79 + lift, z - 0.28),
      0.025,
      const Color(0xFF1D1714),
    );
    game._drawWorldLine(
      canvas,
      _Vec3(x - 0.06, 1.69 + lift, z - 0.29),
      _Vec3(x + 0.08, 1.68 + lift, z - 0.29),
      const Color(0xFF8C5348),
      0.012,
    );
  }
}

class _SoccerBallModel {
  _SoccerBallModel()
    : _panels = [
        _BallPanel(_Vec3(0, 0, 1), 0.23),
        _BallPanel(_Vec3(0.76, 0.18, 0.63), 0.18),
        _BallPanel(_Vec3(-0.72, 0.14, 0.68), 0.18),
        _BallPanel(_Vec3(0.2, 0.72, 0.66), 0.17),
        _BallPanel(_Vec3(-0.15, -0.72, 0.68), 0.17),
        _BallPanel(_Vec3(0.62, -0.55, 0.55), 0.15),
        _BallPanel(_Vec3(-0.64, 0.56, 0.52), 0.15),
        _BallPanel(_Vec3(0.0, 0.0, -1), 0.2),
      ];

  final List<_BallPanel> _panels;
  ui.Image? _sprite;
  double _modelRadius = PenaltyGame._ballRadius;
  int _sourceModelBytes = 0;
  _GlbModel? _sourceModel;

  Future<void> load() async {
    try {
      _sprite = await _loadUiImage('packages/mapness/assets/tifo/sprites/soccer_ball.png');
      _modelRadius = PenaltyGame._ballRadius;
      return;
    } catch (_) {
      // Keep the procedural/GLB path as a fallback if project sprites are absent.
    }

    final raw = await rootBundle.loadString(
      'packages/mapness/assets/tifo/models/soccer_ball.model.json',
    );
    final data = jsonDecode(raw) as Map<String, dynamic>;
    _modelRadius = (data['baseRadius'] as num?)?.toDouble() ?? PenaltyGame._ballRadius;
    final sourceAsset = data['sourceAsset'] as String? ?? '';
    if (sourceAsset.isNotEmpty) {
      final glbData = await rootBundle.load(sourceAsset);
      _sourceModelBytes = glbData.lengthInBytes;
      _sourceModel = _GlbModel.parse(glbData);
    }
    final panels = data['panels'] as List<dynamic>? ?? [];
    if (panels.isEmpty) {
      return;
    }
    _panels
      ..clear()
      ..addAll(
        panels.map((panel) {
          final map = panel as Map<String, dynamic>;
          final normal = (map['normal'] as List<dynamic>).map((value) => (value as num).toDouble()).toList();
          return _BallPanel(
            _Vec3(normal[0], normal[1], normal[2]),
            (map['size'] as num).toDouble(),
          );
        }),
      );
  }

  void render(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 center,
    required double spin,
  }) {
    final sprite = _sprite;
    if (sprite != null) {
      _renderSprite(game, canvas, center: center, spin: spin, image: sprite);
      return;
    }

    game._drawShadow(
      canvas,
      _Vec3(center.x, 0, center.z),
      0.46 + center.y * 0.1,
      (0.34 - center.y * 0.04).clamp(0.08, 0.34).toDouble(),
    );

    final projected = game._project(center);
    if (projected == null) {
      return;
    }

    final sourceScale = _sourceModelBytes > 0 ? 1.0 : 0.92;
    final radius = (_modelRadius * sourceScale * projected.scale).clamp(5.0, 38.0).toDouble();
    final ballRect = Rect.fromCircle(center: projected.offset, radius: radius);
    final ballClip = Path()..addOval(ballRect);

    final sourceModel = _sourceModel;
    if (sourceModel != null) {
      sourceModel.render(
        game,
        canvas,
        origin: center,
        scale: _modelRadius / 0.01,
        yaw: spin * 0.48,
        pitch: spin * 0.31,
        tint: const Color(0xFFECEFF4),
      );
    } else {
      canvas.drawCircle(
        projected.offset,
        radius,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.38, -0.42),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF4F6F8),
              Color(0xFFC4CBD3),
              Color(0xFF77808A),
            ],
            stops: [0.0, 0.46, 0.82, 1.0],
          ).createShader(ballRect),
      );
    }

    canvas.save();
    canvas.clipPath(ballClip);
    _drawSeams(canvas, projected.offset, radius, spin);
    for (final panel in _panels) {
      final normal = _rotated(panel.normal, spin);
      if (normal.z < -0.12) {
        continue;
      }
      final shade = (0.45 + normal.z * 0.45).clamp(0.18, 0.92).toDouble();
      final panelCenter = projected.offset + Offset(normal.x, -normal.y) * radius * (0.72 + normal.z * 0.08);
      final panelRadius = radius * panel.size * (0.72 + normal.z * 0.25);
      _drawPolygon(
        canvas,
        panelCenter,
        5,
        panelRadius,
        spin * 0.7 + normal.x * 0.8,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF101317),
            const Color(0xFF394049),
            1 - shade,
          )!,
      );
      _drawPolygon(
        canvas,
        panelCenter,
        5,
        panelRadius,
        spin * 0.7 + normal.x * 0.8,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.8, radius * 0.018),
      );
    }
    canvas.restore();

    canvas.drawCircle(
      projected.offset,
      radius,
      Paint()
        ..color = const Color(0xFF101820).withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, radius * 0.05),
    );
    canvas.drawCircle(
      projected.offset + Offset(-radius * 0.24, -radius * 0.28),
      radius * 0.13,
      Paint()..color = Colors.white.withValues(alpha: 0.34),
    );
  }

  void _renderSprite(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 center,
    required double spin,
    required ui.Image image,
  }) {
    game._drawShadow(
      canvas,
      _Vec3(center.x, 0, center.z),
      0.48 + center.y * 0.1,
      (0.36 - center.y * 0.04).clamp(0.08, 0.36).toDouble(),
    );

    final projected = game._project(center);
    if (projected == null) {
      return;
    }

    final radius = (_modelRadius * projected.scale).clamp(8.0, 58.0).toDouble();
    final size = radius * 2.18;
    final dst = Rect.fromCenter(center: Offset.zero, width: size, height: size);

    canvas.save();
    canvas.translate(projected.offset.dx, projected.offset.dy);
    canvas.rotate(spin * 0.55);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      dst,
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();

    canvas.drawCircle(
      projected.offset + Offset(-radius * 0.26, -radius * 0.32),
      radius * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.24),
    );
  }

  void _drawSeams(Canvas canvas, Offset center, double radius, double spin) {
    final seamPaint = Paint()
      ..color = const Color(0xFF6E7780).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, radius * 0.025)
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 4; i++) {
      final phase = spin * 0.42 + i * math.pi / 4;
      final rect = Rect.fromCenter(
        center: center + Offset(math.cos(phase), math.sin(phase)) * radius * 0.04,
        width: radius * (1.45 - i * 0.08),
        height: radius * (0.72 + i * 0.12),
      );
      canvas.drawArc(rect, phase, math.pi * 1.24, false, seamPaint);
    }
  }

  _Vec3 _rotated(_Vec3 source, double spin) {
    final yaw = spin * 0.48;
    final pitch = spin * 0.31;
    final x1 = source.x * math.cos(yaw) + source.z * math.sin(yaw);
    final z1 = -source.x * math.sin(yaw) + source.z * math.cos(yaw);
    final y2 = source.y * math.cos(pitch) - z1 * math.sin(pitch);
    final z2 = source.y * math.sin(pitch) + z1 * math.cos(pitch);
    return _Vec3(x1, y2, z2);
  }

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    int sides,
    double radius,
    double rotation,
    Paint paint,
  ) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final angle = rotation - math.pi / 2 + i * math.pi * 2 / sides;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}

class _BallPanel {
  _BallPanel(this.normal, this.size);

  final _Vec3 normal;
  final double size;
}

class _GlbModel {
  _GlbModel(this._triangles, this._center);

  static const int _jsonChunk = 0x4E4F534A;
  static const int _binChunk = 0x004E4942;

  final List<_GlbTriangle> _triangles;
  final _Vec3 _center;

  static _GlbModel parse(ByteData data) {
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    if (bytes.length < 20 || _ascii(bytes, 0, 4) != 'glTF') {
      return _GlbModel(const [], _Vec3.zero());
    }

    var offset = 12;
    Map<String, dynamic>? document;
    var binOffset = 0;

    while (offset + 8 <= bytes.length) {
      final chunkLength = _u32(bytes, offset);
      final chunkType = _u32(bytes, offset + 4);
      final chunkStart = offset + 8;
      final chunkEnd = chunkStart + chunkLength;
      if (chunkEnd > bytes.length) {
        break;
      }
      if (chunkType == _jsonChunk) {
        document = jsonDecode(utf8.decode(bytes.sublist(chunkStart, chunkEnd))) as Map<String, dynamic>;
      } else if (chunkType == _binChunk) {
        binOffset = chunkStart;
      }
      offset = chunkEnd;
    }

    if (document == null || binOffset == 0) {
      return _GlbModel(const [], _Vec3.zero());
    }

    final accessors = document['accessors'] as List<dynamic>? ?? [];
    final bufferViews = document['bufferViews'] as List<dynamic>? ?? [];
    final meshes = document['meshes'] as List<dynamic>? ?? [];
    final triangles = <_GlbTriangle>[];
    var minX = double.infinity;
    var minY = double.infinity;
    var minZ = double.infinity;
    var maxX = -double.infinity;
    var maxY = -double.infinity;
    var maxZ = -double.infinity;

    for (final mesh in meshes.cast<Map<String, dynamic>>()) {
      final primitives = mesh['primitives'] as List<dynamic>? ?? [];
      for (final primitive in primitives.cast<Map<String, dynamic>>()) {
        final attributes = primitive['attributes'] as Map<String, dynamic>? ?? {};
        final positionAccessor = attributes['POSITION'] as int?;
        if (positionAccessor == null) {
          continue;
        }
        final positions = _readVec3Accessor(
          bytes,
          binOffset,
          accessors[positionAccessor] as Map<String, dynamic>,
          bufferViews,
        );
        if (positions.isEmpty) {
          continue;
        }
        for (final vertex in positions) {
          minX = math.min(minX, vertex.x);
          minY = math.min(minY, vertex.y);
          minZ = math.min(minZ, vertex.z);
          maxX = math.max(maxX, vertex.x);
          maxY = math.max(maxY, vertex.y);
          maxZ = math.max(maxZ, vertex.z);
        }

        final indexAccessor = primitive['indices'] as int?;
        final indices = indexAccessor == null
            ? List<int>.generate(positions.length, (index) => index)
            : _readIndexAccessor(
                bytes,
                binOffset,
                accessors[indexAccessor] as Map<String, dynamic>,
                bufferViews,
              );
        for (var i = 0; i + 2 < indices.length; i += 3) {
          final a = indices[i];
          final b = indices[i + 1];
          final c = indices[i + 2];
          if (a < positions.length && b < positions.length && c < positions.length) {
            triangles.add(
              _GlbTriangle(positions[a], positions[b], positions[c]),
            );
          }
        }
      }
    }

    final center = minX.isFinite ? _Vec3((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2) : _Vec3.zero();
    return _GlbModel(triangles, center);
  }

  void render(
    PenaltyGame game,
    Canvas canvas, {
    required _Vec3 origin,
    required double scale,
    required Color tint,
    double yaw = 0,
    double pitch = 0,
    double roll = 0,
  }) {
    if (_triangles.isEmpty) {
      return;
    }
    final drawList = <_ProjectedTriangle>[];
    for (final triangle in _triangles) {
      final a = _transform(triangle.a, origin, scale, yaw, pitch, roll);
      final b = _transform(triangle.b, origin, scale, yaw, pitch, roll);
      final c = _transform(triangle.c, origin, scale, yaw, pitch, roll);
      final pa = game._project(a);
      final pb = game._project(b);
      final pc = game._project(c);
      if (pa == null || pb == null || pc == null) {
        continue;
      }
      final area = _signedArea(pa.offset, pb.offset, pc.offset);
      if (area.abs() < 0.2) {
        continue;
      }
      final normal = _normal(a, b, c);
      final light = _shade(normal);
      drawList.add(
        _ProjectedTriangle(
          pa.offset,
          pb.offset,
          pc.offset,
          (a.z + b.z + c.z) / 3,
          _mixShade(tint, light),
        ),
      );
    }

    drawList.sort((a, b) => b.depth.compareTo(a.depth));
    for (final triangle in drawList) {
      final path = Path()
        ..moveTo(triangle.a.dx, triangle.a.dy)
        ..lineTo(triangle.b.dx, triangle.b.dy)
        ..lineTo(triangle.c.dx, triangle.c.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = triangle.color);
    }
  }

  _Vec3 _transform(
    _Vec3 source,
    _Vec3 origin,
    double scale,
    double yaw,
    double pitch,
    double roll,
  ) {
    var x = source.x - _center.x;
    var y = source.z;
    var z = source.y - _center.y;

    final cy = math.cos(yaw);
    final sy = math.sin(yaw);
    final x1 = x * cy - z * sy;
    final z1 = x * sy + z * cy;
    x = x1;
    z = z1;

    final cp = math.cos(pitch);
    final sp = math.sin(pitch);
    final y1 = y * cp - z * sp;
    final z2 = y * sp + z * cp;
    y = y1;
    z = z2;

    final cr = math.cos(roll);
    final sr = math.sin(roll);
    final x2 = x * cr - y * sr;
    final y2 = x * sr + y * cr;

    return _Vec3(
      origin.x + x2 * scale,
      origin.y + y2 * scale,
      origin.z + z * scale,
    );
  }

  static List<_Vec3> _readVec3Accessor(
    Uint8List bytes,
    int binOffset,
    Map<String, dynamic> accessor,
    List<dynamic> bufferViews,
  ) {
    if (accessor['componentType'] != 5126 || accessor['type'] != 'VEC3') {
      return const [];
    }
    final view = bufferViews[accessor['bufferView'] as int] as Map<String, dynamic>;
    final count = accessor['count'] as int;
    final stride = view['byteStride'] as int? ?? 12;
    final start = binOffset + (view['byteOffset'] as int? ?? 0) + (accessor['byteOffset'] as int? ?? 0);
    final data = ByteData.sublistView(bytes);
    return List<_Vec3>.generate(count, (index) {
      final offset = start + index * stride;
      return _Vec3(
        data.getFloat32(offset, Endian.little),
        data.getFloat32(offset + 4, Endian.little),
        data.getFloat32(offset + 8, Endian.little),
      );
    });
  }

  static List<int> _readIndexAccessor(
    Uint8List bytes,
    int binOffset,
    Map<String, dynamic> accessor,
    List<dynamic> bufferViews,
  ) {
    final view = bufferViews[accessor['bufferView'] as int] as Map<String, dynamic>;
    final count = accessor['count'] as int;
    final componentType = accessor['componentType'] as int;
    final componentSize = switch (componentType) {
      5121 => 1,
      5123 => 2,
      5125 => 4,
      _ => 0,
    };
    if (componentSize == 0) {
      return const [];
    }
    final stride = view['byteStride'] as int? ?? componentSize;
    final start = binOffset + (view['byteOffset'] as int? ?? 0) + (accessor['byteOffset'] as int? ?? 0);
    final data = ByteData.sublistView(bytes);
    return List<int>.generate(count, (index) {
      final offset = start + index * stride;
      return switch (componentType) {
        5121 => data.getUint8(offset),
        5123 => data.getUint16(offset, Endian.little),
        5125 => data.getUint32(offset, Endian.little),
        _ => 0,
      };
    });
  }

  static int _u32(Uint8List bytes, int offset) => ByteData.sublistView(bytes).getUint32(offset, Endian.little);

  static String _ascii(Uint8List bytes, int start, int length) =>
      String.fromCharCodes(bytes.sublist(start, start + length));

  static double _signedArea(Offset a, Offset b, Offset c) =>
      (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);

  static _Vec3 _normal(_Vec3 a, _Vec3 b, _Vec3 c) {
    final ux = b.x - a.x;
    final uy = b.y - a.y;
    final uz = b.z - a.z;
    final vx = c.x - a.x;
    final vy = c.y - a.y;
    final vz = c.z - a.z;
    return _Vec3(uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx);
  }

  static double _shade(_Vec3 normal) {
    final length = math.sqrt(
      normal.x * normal.x + normal.y * normal.y + normal.z * normal.z,
    );
    if (length == 0) {
      return 0.55;
    }
    final nx = normal.x / length;
    final ny = normal.y / length;
    final nz = normal.z / length;
    final light = nx * -0.28 + ny * 0.82 + nz * -0.5;
    return (0.44 + light * 0.38).clamp(0.22, 0.9).toDouble();
  }

  static Color _mixShade(Color color, double shade) {
    final target = shade > 0.55 ? _lighten(color, shade - 0.55) : _darken(color, 0.55 - shade);
    return Color.lerp(color, target, 0.8)!;
  }
}

class _GlbTriangle {
  const _GlbTriangle(this.a, this.b, this.c);

  final _Vec3 a;
  final _Vec3 b;
  final _Vec3 c;
}

class _ProjectedTriangle {
  const _ProjectedTriangle(this.a, this.b, this.c, this.depth, this.color);

  final Offset a;
  final Offset b;
  final Offset c;
  final double depth;
  final Color color;
}

class _Vec3 {
  _Vec3(this.x, this.y, this.z);

  factory _Vec3.zero() => _Vec3(0, 0, 0);

  double x;
  double y;
  double z;

  _Vec3 copy() => _Vec3(x, y, z);
}

class _Projected {
  const _Projected(this.offset, this.scale);

  final Offset offset;
  final double scale;
}

class _SpriteSheet {
  const _SpriteSheet({
    required this.image,
    required this.frameWidth,
    required this.frameHeight,
    required this.frames,
  });

  final ui.Image image;
  final int frameWidth;
  final int frameHeight;
  final int frames;

  Rect frameRect(int frame) {
    final index = frame.clamp(0, frames - 1);
    return Rect.fromLTWH(
      (index * frameWidth).toDouble(),
      0,
      frameWidth.toDouble(),
      frameHeight.toDouble(),
    );
  }
}

/// Row-major sprite atlas — one big PNG holding every pose the keeper can
/// strike. Each motion sequence is just an ordered list of cell indices into
/// this atlas (see [_GoalkeeperModel._motionFrames]).
class _KeeperAtlas {
  const _KeeperAtlas({
    required this.image,
    required this.cellWidth,
    required this.cellHeight,
    required this.cols,
    required this.rows,
    this.reverseColumns = false,
  });

  final ui.Image image;
  final int cellWidth;
  final int cellHeight;
  final int cols;
  final int rows;
  final bool reverseColumns;

  Rect cellRect(int index) {
    final clamped = index.clamp(0, cols * rows - 1);

    final row = clamped ~/ cols;

    final col = reverseColumns ? cols - 1 - (clamped % cols) : clamped % cols;

    return Rect.fromLTWH(
      (col * cellWidth).toDouble(),
      (row * cellHeight).toDouble(),
      cellWidth.toDouble(),
      cellHeight.toDouble(),
    );
  }
}

// Ball-kick SFX — one is picked at random per shot; add more file paths
// here as additional clips become available, nothing else needs to change.
const List<String> _kickSounds = [
  'packages/mapness/assets/tifo/audio/kick_1.mp3',
];

/// Fire-and-forget one-shot SFX: picks a random clip from [tracks], plays
/// it once, and disposes itself when done. A missing/corrupt asset is
/// swallowed rather than thrown — sound effects are a nice-to-have and must
/// never take the game down with them.
Future<void> _playRandomSfx(List<String> tracks) async {
  if (tracks.isEmpty) {
    return;
  }
  final track = tracks[math.Random().nextInt(tracks.length)];
  // just_audio_background allows exactly one background-registered player
  // app-wide, and _startAmbience's looping player holds that slot for the
  // whole game — a second AudioPlayer() here throws "supports only a single
  // player instance". A one-shot kick doesn't need lock-screen/background
  // integration, so borrow the plain (non-background) platform just for
  // this player's lifetime, then hand the slot back to just_audio_background.
  final backgroundPlatform = JustAudioPlatform.instance;
  JustAudioPlatform.instance = MethodChannelJustAudio();
  final player = AudioPlayer();
  try {
    await player.setAsset(track);
    await player.play();
    // `play()` completes once the native play *request* is sent, not once
    // the clip finishes — disposing right after would cut the sound off
    // before it's audible. Wait for it to actually reach `completed` first.
    await player.playerStateStream.firstWhere(
      (state) => state.processingState == ProcessingState.completed,
    );
    debugPrint('[tifo-audio] sfx played: $track');
  } catch (e, st) {
    // Ignored at runtime — see doc comment above. Still log it: this is the
    // only signal we'd otherwise have for diagnosing "no sound" reports.
    debugPrint('[tifo-audio] sfx failed: $e\n$st');
  } finally {
    await player.dispose();
    JustAudioPlatform.instance = backgroundPlatform;
  }
}

Future<ui.Image> _loadUiImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<ui.Image?> _loadOptionalUiImage(String assetPath) async {
  try {
    return await _loadUiImage(assetPath);
  } catch (_) {
    return null;
  }
}

Future<_SpriteSheet?> _loadOptionalSheet(
  String assetPath, {
  required int frameWidth,
  required int frameHeight,
  required int frames,
}) async {
  try {
    final image = await _loadUiImage(assetPath);
    return _SpriteSheet(
      image: image,
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      frames: frames,
    );
  } catch (_) {
    return null;
  }
}

Future<ui.Image> _loadPixelatedUiImage(
  String assetPath,
  int targetHeight,
) async {
  final source = await _loadUiImage(assetPath);
  final targetWidth = math.max(
    1,
    (targetHeight * source.width / source.height).round(),
  );
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    source,
    Rect.fromLTWH(0, 0, source.width.toDouble(), source.height.toDouble()),
    Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
    Paint()..filterQuality = FilterQuality.low,
  );
  final picture = recorder.endRecording();
  return picture.toImage(targetWidth, targetHeight);
}

Paint _spritePaint([double opacity = 1]) {
  final paint = Paint()..filterQuality = FilterQuality.high;
  if (opacity < 0.995) {
    paint.colorFilter = ColorFilter.mode(
      Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0).toDouble()),
      BlendMode.modulate,
    );
  }
  return paint;
}

double _smoothStep(num value) {
  final t = value.clamp(0.0, 1.0).toDouble();
  return t * t * (3 - 2 * t);
}

double _easeOutCubic(num value) {
  final t = value.clamp(0.0, 1.0).toDouble();
  return 1 - math.pow(1 - t, 3).toDouble();
}

extension on double {
  double get signOrZero {
    if (this > 0) {
      return 1;
    }
    if (this < 0) {
      return -1;
    }
    return 0;
  }
}

Color _lighten(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0).toDouble()).toColor();
}

Color _darken(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0).toDouble()).toColor();
}

Color _colorFromHex(String value) {
  final normalized = value.replaceFirst('#', '').padLeft(8, 'F');
  return Color(int.parse(normalized, radix: 16));
}

// ---------------------------------------------------------------------------
// Мини-игра «Penalty» в неоновом стиле (третий режим в тулбаре).
// ---------------------------------------------------------------------------

class MiniFootballGameWidget extends StatefulWidget {
  const MiniFootballGameWidget({super.key, this.style = MiniGameStyle.cyber});

  final MiniGameStyle style;

  @override
  State<MiniFootballGameWidget> createState() => _MiniFootballGameWidgetState();
}

class _MiniFootballGameWidgetState extends State<MiniFootballGameWidget> {
  late final MiniFootballGame _game;

  @override
  void initState() {
    super.initState();
    _game = MiniFootballGame(style: widget.style);
  }

  @override
  Widget build(BuildContext context) {
    final chrome = _MiniChrome.of(widget.style);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: chrome.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 86),
          child: Column(
            children: [
              Text(chrome.title, style: chrome.titleStyle),
              const SizedBox(height: 12),
              _MiniGameHud(game: _game, chrome: chrome),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: chrome.borderColor.withValues(alpha: 0.7),
                        width: chrome.borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: GameWidget<MiniFootballGame>(game: _game),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniGameHud extends StatelessWidget {
  const _MiniGameHud({required this.game, required this.chrome});

  final MiniFootballGame game;
  final _MiniChrome chrome;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _MiniGameBadge(
        icon: Icons.emoji_events,
        label: 'Score',
        iconColor: chrome.scoreIconColor,
        background: chrome.scoreBadgeBg,
        textColor: chrome.badgeTextColor,
      ),
      const Spacer(),
      ValueListenableBuilder<int>(
        valueListenable: game.scoreNotifier,
        builder: (_, score, _) => ValueListenableBuilder<int>(
          valueListenable: game.savesNotifier,
          builder: (_, saves, _) => _MiniGameScoreBoard(
            left: score,
            right: saves,
            chrome: chrome,
          ),
        ),
      ),
      const Spacer(),
      ValueListenableBuilder<int>(
        valueListenable: game.attemptsNotifier,
        builder: (_, attempts, _) => _MiniGameBadge(
          icon: Icons.monetization_on,
          label: 'Attempt $attempts',
          iconColor: chrome.attemptIconColor,
          background: chrome.attemptBadgeBg,
          textColor: chrome.badgeTextColor,
        ),
      ),
    ],
  );
}

class _MiniGameBadge extends StatelessWidget {
  const _MiniGameBadge({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.background,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: textColor.withValues(alpha: 0.18)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _MiniGameScoreBoard extends StatelessWidget {
  const _MiniGameScoreBoard({
    required this.left,
    required this.right,
    required this.chrome,
  });

  final int left;
  final int right;
  final _MiniChrome chrome;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: chrome.scoreboardBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: chrome.scoreboardText.withValues(alpha: 0.18),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$left',
              style: TextStyle(
                color: chrome.scoreboardText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              chrome.scoreLabel,
              style: TextStyle(
                color: chrome.scoreSeparator,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$right',
              style: TextStyle(
                color: chrome.scoreboardText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          height: 2,
          width: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: chrome.scoreboardAccent),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Галерея стилей мини-игры — карусель с превью трёх альтернативных оформлений.
// ---------------------------------------------------------------------------

class StylesGalleryWidget extends StatefulWidget {
  const StylesGalleryWidget({super.key});

  @override
  State<StylesGalleryWidget> createState() => _StylesGalleryWidgetState();
}

class _StylesGalleryWidgetState extends State<StylesGalleryWidget> {
  static const List<_StyleEntry> _entries = [
    _StyleEntry(
      style: MiniGameStyle.stadium,
      name: 'Stadium',
      tagline: 'Realistic turf, white lines, night floodlights',
    ),
    _StyleEntry(
      style: MiniGameStyle.flat,
      name: 'Minimal',
      tagline: 'Clean shapes, pastel palette, no noise',
    ),
    _StyleEntry(
      style: MiniGameStyle.comic,
      name: 'Comic',
      tagline: 'Thick outlines, halftone, bright and loud',
    ),
    _StyleEntry(
      style: MiniGameStyle.pixel,
      name: 'Pixel art',
      tagline: '16-bit sunset, procedural keeper, chunks and dithering',
    ),
    _StyleEntry(
      style: MiniGameStyle.lowPoly,
      name: 'Low-poly',
      tagline: 'Faceted edges, flat shadows, mountains on the horizon',
    ),
  ];

  late final PageController _ctrl;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 0.84);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openStyle(MiniGameStyle style) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _PlayableStyleScreen(style: style),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = _entries[_index];
    return ColoredBox(
      color: const Color(0xFF0A0420),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 86),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Choose a style',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  entry.tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _entries.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: _StylePreviewCard(
                      entry: _entries[i],
                      selected: i == _index,
                      onTap: () => _openStyle(_entries[i].style),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_entries.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openStyle(entry.style),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1C0A3E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    child: Text('Play — ${entry.name}'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleEntry {
  const _StyleEntry({
    required this.style,
    required this.name,
    required this.tagline,
  });
  final MiniGameStyle style;
  final String name;
  final String tagline;
}

class _StylePreviewCard extends StatelessWidget {
  const _StylePreviewCard({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final _StyleEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = selected ? 1.0 : 0.94;
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      scale: scale,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Превью — реальный виджет игры с выключенным интерактивом.
              IgnorePointer(
                child: MiniFootballGameWidget(
                  key: ValueKey('preview-${entry.style.name}'),
                  style: entry.style,
                ),
              ),
              // Подпись внизу.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.62),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: 16,
                              color: Color(0xFF1C0A3E),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Play',
                              style: TextStyle(
                                color: Color(0xFF1C0A3E),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayableStyleScreen extends StatelessWidget {
  const _PlayableStyleScreen({required this.style});
  final MiniGameStyle style;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(child: MiniFootballGameWidget(style: style)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.black.withValues(alpha: 0.32),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

enum _MiniShotState { aiming, flying, goal, saved, missed }

enum MiniGameStyle { cyber, stadium, flat, comic, pixel, lowPoly }

class _MiniChrome {
  const _MiniChrome({
    required this.title,
    required this.titleStyle,
    required this.gradient,
    required this.borderColor,
    required this.borderWidth,
    required this.scoreBadgeBg,
    required this.scoreIconColor,
    required this.attemptBadgeBg,
    required this.attemptIconColor,
    required this.scoreboardBg,
    required this.scoreboardText,
    required this.scoreboardAccent,
    required this.badgeTextColor,
    required this.scoreLabel,
    required this.scoreSeparator,
  });

  final String title;
  final TextStyle titleStyle;
  final List<Color> gradient;
  final Color borderColor;
  final double borderWidth;
  final Color scoreBadgeBg;
  final Color scoreIconColor;
  final Color attemptBadgeBg;
  final Color attemptIconColor;
  final Color scoreboardBg;
  final Color scoreboardText;
  final List<Color> scoreboardAccent;
  final Color badgeTextColor;
  final String scoreLabel; // "NUD" / "vs" / ...
  final Color scoreSeparator;

  static _MiniChrome of(MiniGameStyle s) => switch (s) {
    MiniGameStyle.cyber => const _MiniChrome(
      title: 'MINI FOOTBALL GAME',
      titleStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
      gradient: [Color(0xFF0A0420), Color(0xFF1C0A3E), Color(0xFF2A1466)],
      borderColor: Color(0xFF7C5BFF),
      borderWidth: 1.2,
      scoreBadgeBg: Color(0x4D6B2BC9),
      scoreIconColor: Color(0xFFE6B8FF),
      attemptBadgeBg: Color(0x4D3A2A0A),
      attemptIconColor: Color(0xFFFFD15B),
      scoreboardBg: Color(0x66000000),
      scoreboardText: Colors.white,
      scoreboardAccent: [Color(0xFF6BFFF6), Color(0xFFB46BFF)],
      badgeTextColor: Colors.white,
      scoreLabel: 'NUD',
      scoreSeparator: Color(0xFFB8B0CF),
    ),
    MiniGameStyle.stadium => const _MiniChrome(
      title: 'PENALTY SHOOTOUT',
      titleStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.4,
      ),
      gradient: [Color(0xFF0F1B33), Color(0xFF182846), Color(0xFF223C70)],
      borderColor: Color(0xFFE0E5F0),
      borderWidth: 1.0,
      scoreBadgeBg: Color(0xCC0B2545),
      scoreIconColor: Color(0xFFFFD24A),
      attemptBadgeBg: Color(0xCC0B2545),
      attemptIconColor: Color(0xFFFFD24A),
      scoreboardBg: Color(0xE60B2545),
      scoreboardText: Colors.white,
      scoreboardAccent: [Color(0xFFFFD24A), Color(0xFFEAEAEA)],
      badgeTextColor: Colors.white,
      scoreLabel: 'VS',
      scoreSeparator: Color(0xFFAAB3C2),
    ),
    MiniGameStyle.flat => const _MiniChrome(
      title: 'Penalty',
      titleStyle: TextStyle(
        color: Color(0xFF3A2E76),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      gradient: [Color(0xFFFFE6D5), Color(0xFFFFD7C2)],
      borderColor: Color(0xFFE6735A),
      borderWidth: 2.5,
      scoreBadgeBg: Color(0xFFFFEFE2),
      scoreIconColor: Color(0xFFE6735A),
      attemptBadgeBg: Color(0xFFFFEFE2),
      attemptIconColor: Color(0xFF59489E),
      scoreboardBg: Color(0xFFFFFFFF),
      scoreboardText: Color(0xFF3A2E76),
      scoreboardAccent: [Color(0xFF45C7AE), Color(0xFFE6735A)],
      badgeTextColor: Color(0xFF3A2E76),
      scoreLabel: 'vs',
      scoreSeparator: Color(0xFF59489E),
    ),
    MiniGameStyle.comic => const _MiniChrome(
      title: 'GOOOOAL!',
      titleStyle: TextStyle(
        color: Color(0xFF111111),
        fontSize: 26,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
      gradient: [Color(0xFFFFE940), Color(0xFFFFB300)],
      borderColor: Color(0xFF111111),
      borderWidth: 4,
      scoreBadgeBg: Color(0xFFFFFFFF),
      scoreIconColor: Color(0xFFFF4F58),
      attemptBadgeBg: Color(0xFFFFFFFF),
      attemptIconColor: Color(0xFF2EC4FF),
      scoreboardBg: Color(0xFFFFFFFF),
      scoreboardText: Color(0xFF111111),
      scoreboardAccent: [Color(0xFFFF4F58), Color(0xFF2EC4FF)],
      badgeTextColor: Color(0xFF111111),
      scoreLabel: 'VS',
      scoreSeparator: Color(0xFF111111),
    ),
    MiniGameStyle.pixel => const _MiniChrome(
      title: 'PIXEL PENALTY',
      titleStyle: TextStyle(
        color: Color(0xFFFFE066),
        fontSize: 18,
        fontWeight: FontWeight.w900,
        letterSpacing: 3.0,
      ),
      gradient: [Color(0xFF1B0C3A), Color(0xFF311A66), Color(0xFFFF6B5C)],
      borderColor: Color(0xFFFFE066),
      borderWidth: 3.0,
      scoreBadgeBg: Color(0xFF1B0C3A),
      scoreIconColor: Color(0xFFFFE066),
      attemptBadgeBg: Color(0xFF1B0C3A),
      attemptIconColor: Color(0xFFFFE066),
      scoreboardBg: Color(0xFF1B0C3A),
      scoreboardText: Color(0xFFFFE066),
      scoreboardAccent: [Color(0xFFFF5577), Color(0xFFFFE066)],
      badgeTextColor: Color(0xFFFFE066),
      scoreLabel: '×',
      scoreSeparator: Color(0xFFFF5577),
    ),
    MiniGameStyle.lowPoly => const _MiniChrome(
      title: 'POLY KICK',
      titleStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.6,
      ),
      gradient: [Color(0xFF274060), Color(0xFF3E5F8A), Color(0xFF8DB9D8)],
      borderColor: Color(0xFFFFD56B),
      borderWidth: 1.5,
      scoreBadgeBg: Color(0xCC1B2F4A),
      scoreIconColor: Color(0xFFFFD56B),
      attemptBadgeBg: Color(0xCC1B2F4A),
      attemptIconColor: Color(0xFFFF8C66),
      scoreboardBg: Color(0xCC1B2F4A),
      scoreboardText: Colors.white,
      scoreboardAccent: [Color(0xFFFFD56B), Color(0xFFFF8C66)],
      badgeTextColor: Colors.white,
      scoreLabel: 'vs',
      scoreSeparator: Color(0xFFFFD56B),
    ),
  };
}

class _MiniPalette {
  const _MiniPalette({
    required this.ballFill,
    required this.ballSpot,
    required this.ballGlow,
    required this.hintColor,
    required this.aimPreview,
    required this.goalBannerColor,
    required this.saveBannerColor,
    required this.missBannerColor,
    required this.keeperHaloPrimary,
    required this.keeperHaloSecondary,
  });

  final Color ballFill;
  final Color ballSpot;
  final Color ballGlow;
  final Color hintColor;
  final Color aimPreview;
  final Color goalBannerColor;
  final Color saveBannerColor;
  final Color missBannerColor;
  final Color keeperHaloPrimary;
  final Color keeperHaloSecondary;

  static _MiniPalette of(MiniGameStyle s) => switch (s) {
    MiniGameStyle.cyber => const _MiniPalette(
      ballFill: Colors.white,
      ballSpot: Color(0xFF0E1130),
      ballGlow: Color(0xFF6BFFF6),
      hintColor: Colors.white,
      aimPreview: Color(0xFF6BFFF6),
      goalBannerColor: Color(0xFF6BFFB4),
      saveBannerColor: Color(0xFFFF6BD6),
      missBannerColor: Color(0xFFFFD15B),
      keeperHaloPrimary: Color(0xFFB46BFF),
      keeperHaloSecondary: Color(0xFF6BFFF6),
    ),
    MiniGameStyle.stadium => const _MiniPalette(
      ballFill: Color(0xFFFAFAFA),
      ballSpot: Color(0xFF1A1A1A),
      ballGlow: Color(0x55FFFFFF),
      hintColor: Color(0xE6FFFFFF),
      aimPreview: Color(0xCCFFFFFF),
      goalBannerColor: Color(0xFFFFD24A),
      saveBannerColor: Color(0xFFEAEAEA),
      missBannerColor: Color(0xFFE07A5F),
      keeperHaloPrimary: Color(0x00000000),
      keeperHaloSecondary: Color(0x00000000),
    ),
    MiniGameStyle.flat => const _MiniPalette(
      ballFill: Color(0xFFFFF6E5),
      ballSpot: Color(0xFFE6735A),
      ballGlow: Color(0x00000000),
      hintColor: Color(0xFF59489E),
      aimPreview: Color(0xFFE6735A),
      goalBannerColor: Color(0xFF45C7AE),
      saveBannerColor: Color(0xFFE6735A),
      missBannerColor: Color(0xFFFFB55A),
      keeperHaloPrimary: Color(0xFFFFB55A),
      keeperHaloSecondary: Color(0x00000000),
    ),
    MiniGameStyle.comic => const _MiniPalette(
      ballFill: Colors.white,
      ballSpot: Color(0xFF111111),
      ballGlow: Color(0xFFFFE940),
      hintColor: Color(0xFF111111),
      aimPreview: Color(0xFFFF4F58),
      goalBannerColor: Color(0xFFFF4F58),
      saveBannerColor: Color(0xFF2EC4FF),
      missBannerColor: Color(0xFFFFE940),
      keeperHaloPrimary: Color(0xFFFFE940),
      keeperHaloSecondary: Color(0x00000000),
    ),
    MiniGameStyle.pixel => const _MiniPalette(
      ballFill: Color(0xFFFFFFFF),
      ballSpot: Color(0xFF1B1B2A),
      ballGlow: Color(0x00000000),
      hintColor: Color(0xFFFFE066),
      aimPreview: Color(0xFFFFE066),
      goalBannerColor: Color(0xFFFFE066),
      saveBannerColor: Color(0xFFFF5577),
      missBannerColor: Color(0xFFA0A0FF),
      keeperHaloPrimary: Color(0x00000000),
      keeperHaloSecondary: Color(0x00000000),
    ),
    MiniGameStyle.lowPoly => const _MiniPalette(
      ballFill: Color(0xFFF1F4FA),
      ballSpot: Color(0xFF24304B),
      ballGlow: Color(0x00000000),
      hintColor: Color(0xFFFFD56B),
      aimPreview: Color(0xFFFFD56B),
      goalBannerColor: Color(0xFF7CE8B7),
      saveBannerColor: Color(0xFFFFB178),
      missBannerColor: Color(0xFFFF6B8A),
      keeperHaloPrimary: Color(0x00000000),
      keeperHaloSecondary: Color(0x00000000),
    ),
  };
}

class MiniFootballGame extends FlameGame with DragCallbacks {
  MiniFootballGame({this.style = MiniGameStyle.cyber});

  final MiniGameStyle style;

  _MiniPalette get _palette => _MiniPalette.of(style);

  static const int _maxAttempts = 5;

  final scoreNotifier = ValueNotifier<int>(0);
  final savesNotifier = ValueNotifier<int>(0);
  final attemptsNotifier = ValueNotifier<int>(_maxAttempts);

  final _random = math.Random();

  _MiniShotState _state = _MiniShotState.aiming;

  // Координаты в пространстве [0..1] относительно size, преобразуются в пиксели
  // при рендере, чтобы игра адекватно реагировала на ресайз.
  Vector2 _ballPos = Vector2(0.5, 0.86);
  Vector2 _ballStart = Vector2(0.5, 0.86);
  Vector2 _ballTarget = Vector2(0.5, 0.22);

  Offset? _dragStart;
  Offset? _dragCurrent;

  double _shotProgress = 0;
  double _shotDuration = 0.65;
  double _resultTime = 0;
  double _hintPhase = 0;

  // Вратарь
  double _keeperX = 0.5; // позиция в [0..1] вдоль линии ворот
  double _keeperTargetX = 0.5;
  final double _keeperReach = 0.12; // ширина «руки» относительно width
  bool _shotResolved = false;
  _KeeperDive _diveStyle = _KeeperDive.mid;
  double _diveDirection = 0; // -1 левый прыжок, +1 правый, 0 без

  // Спрайты вратаря (фотореалистичные)
  ui.Image? _keeperIdleSprite;
  ui.Image? _keeperDiveMidSprite;
  ui.Image? _keeperDiveLowSprite;
  ui.Image? _keeperDiveHighSprite;

  // Параметры дуги полёта
  double _arcHeight = 0.18;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      final sprites = await Future.wait([
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_idle.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_left.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_low_left.png'),
        _loadUiImage('packages/mapness/assets/tifo/sprites/goalkeeper_dive_high_left.png'),
      ]);
      _keeperIdleSprite = sprites[0];
      _keeperDiveMidSprite = sprites[1];
      _keeperDiveLowSprite = sprites[2];
      _keeperDiveHighSprite = sprites[3];
    } catch (_) {
      // Не удалось загрузить — отрисуем процедурно как раньше.
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _hintPhase += dt;

    switch (_state) {
      case _MiniShotState.aiming:
        // Плавное покачивание вратаря
        _keeperX = 0.5 + math.sin(_hintPhase * 1.4) * 0.18;
        break;
      case _MiniShotState.flying:
        _shotProgress += dt / _shotDuration;
        _keeperX += (_keeperTargetX - _keeperX) * (1 - math.exp(-dt * 6.0));
        if (_shotProgress >= 1) {
          _shotProgress = 1;
          if (!_shotResolved) {
            _resolveShot();
          }
        }
        _updateBallPosition();
        break;
      case _MiniShotState.goal:
      case _MiniShotState.saved:
      case _MiniShotState.missed:
        _resultTime += dt;
        _keeperX += (_keeperTargetX - _keeperX) * (1 - math.exp(-dt * 4.5));
        if (_state == _MiniShotState.goal) {
          // мяч продолжает лететь чуть вверх и затухает
          _ballPos = Vector2(_ballTarget.x, _ballTarget.y - _resultTime * 0.08);
        } else if (_state == _MiniShotState.saved) {
          final bounce = math.sin(_resultTime * 8) * 0.04 * math.exp(-_resultTime * 2);
          _ballPos = Vector2(_ballTarget.x + bounce, _ballTarget.y + 0.02);
        } else {
          _ballPos = Vector2(
            _ballTarget.x,
            _ballTarget.y - 0.05 + _resultTime * 0.25,
          );
        }
        if (_resultTime > 1.4) {
          _resetRound();
        }
        break;
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_state != _MiniShotState.aiming) return;
    _dragStart = event.canvasPosition.toOffset();
    _dragCurrent = _dragStart;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_state != _MiniShotState.aiming) return;
    _dragCurrent = event.canvasEndPosition.toOffset();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_state != _MiniShotState.aiming) {
      _dragStart = null;
      _dragCurrent = null;
      return;
    }
    final start = _dragStart;
    final end = _dragCurrent ?? start;
    _dragStart = null;
    _dragCurrent = null;
    if (start == null || end == null) return;
    final delta = end - start;
    // Свайп должен быть направлен вверх и иметь достаточную длину
    if (delta.dy > -20 || delta.distance < 30) return;
    _launchShot(delta);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _dragStart = null;
    _dragCurrent = null;
  }

  void _launchShot(Offset swipe) {
    // Сила удара: длина свайпа по вертикали → время полёта (меньше = быстрее)
    final s = size;
    final swipeNorm = (-swipe.dy / s.y).clamp(0.15, 1.2);
    _shotDuration = (0.85 - swipeNorm * 0.4).clamp(0.42, 0.85).toDouble();

    // Горизонтальная цель: смещение от центра по dx
    final aimDx = (swipe.dx / (s.x * 0.5)).clamp(-1.1, 1.1).toDouble();
    final targetX = (0.5 + aimDx * 0.32).clamp(0.18, 0.82).toDouble();

    // Высота попадания мяча в плоскости ворот (чем выше свайп, тем выше мяч).
    final aimY = (0.40 - swipeNorm * 0.18).clamp(0.22, 0.46).toDouble();
    _ballTarget = Vector2(targetX, aimY);
    _ballStart = _ballPos.clone();
    _shotProgress = 0;
    _shotResolved = false;
    _arcHeight = 0.18 + swipeNorm * 0.06;
    _state = _MiniShotState.flying;

    // Вратарь выбирает зону: 0 — лево, 1 — центр, 2 — право.
    final zone = _random.nextInt(3);
    _keeperTargetX = [0.28, 0.5, 0.72][zone];
    // Стиль прыжка по высоте мяча: верх / середина / низ.
    if (aimY < 0.28) {
      _diveStyle = _KeeperDive.high;
    } else if (aimY > 0.38) {
      _diveStyle = _KeeperDive.low;
    } else {
      _diveStyle = _KeeperDive.mid;
    }
    _diveDirection = (_keeperTargetX - 0.5).signOrZero;
  }

  void _updateBallPosition() {
    final t = _shotProgress.clamp(0.0, 1.0);
    final lx = _ballStart.x + (_ballTarget.x - _ballStart.x) * t;
    final ly = _ballStart.y + (_ballTarget.y - _ballStart.y) * t;
    // Парабола: добавляем «горб» вверх — мяч идёт по дуге
    final arc = math.sin(t * math.pi) * _arcHeight;
    _ballPos = Vector2(lx, ly - arc);
  }

  void _resolveShot() {
    _shotResolved = true;
    final dx = (_ballTarget.x - _keeperX).abs();
    final caught = dx < _keeperReach;
    attemptsNotifier.value = math.max(0, attemptsNotifier.value - 1);
    if (caught) {
      _state = _MiniShotState.saved;
      savesNotifier.value += 1;
    } else {
      _state = _MiniShotState.goal;
      scoreNotifier.value += 1;
    }
    _resultTime = 0;
  }

  void _resetRound() {
    if (attemptsNotifier.value == 0) {
      // Раунд окончен — обнуляем счёт и попытки
      scoreNotifier.value = 0;
      savesNotifier.value = 0;
      attemptsNotifier.value = _maxAttempts;
    }
    _state = _MiniShotState.aiming;
    _ballPos = Vector2(0.5, 0.86);
    _ballStart = _ballPos.clone();
    _ballTarget = Vector2(0.5, 0.40);
    _shotProgress = 0;
    _resultTime = 0;
    _shotResolved = false;
    _diveDirection = 0;
    _diveStyle = _KeeperDive.mid;
    _keeperTargetX = 0.5;
  }

  @override
  void render(Canvas canvas) {
    _paintScene(canvas);
    super.render(canvas);
  }

  void _paintScene(Canvas canvas) {
    final s = size;
    final w = s.x;
    final h = s.y;

    _paintField(canvas, w, h);
    _paintGoal(canvas, w, h);
    _paintKeeper(canvas, w, h);
    _paintBall(canvas, w, h);
    _paintSwipeHint(canvas, w, h);
    _paintAimPreview(canvas, w, h);
    _paintResultBanner(canvas, w, h);
  }

  void _paintField(Canvas canvas, double w, double h) {
    switch (style) {
      case MiniGameStyle.cyber:
        _paintFieldCyber(canvas, w, h);
        break;
      case MiniGameStyle.stadium:
        _paintFieldStadium(canvas, w, h);
        break;
      case MiniGameStyle.flat:
        _paintFieldFlat(canvas, w, h);
        break;
      case MiniGameStyle.comic:
        _paintFieldComic(canvas, w, h);
        break;
      case MiniGameStyle.pixel:
        _paintFieldPixel(canvas, w, h);
        break;
      case MiniGameStyle.lowPoly:
        _paintFieldLowPoly(canvas, w, h);
        break;
    }
  }

  void _paintFieldCyber(Canvas canvas, double w, double h) {
    final groundY = h * 0.62;
    final perspectiveTop = Path()
      ..moveTo(w * 0.02, h * 0.96)
      ..lineTo(w * 0.98, h * 0.96)
      ..lineTo(w * 0.82, groundY)
      ..lineTo(w * 0.18, groundY)
      ..close();
    canvas.drawPath(
      perspectiveTop,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF170A3A).withValues(alpha: 0.0),
            const Color(0xFF1F2D7D).withValues(alpha: 0.45),
          ],
        ).createShader(Rect.fromLTWH(0, groundY, w, h - groundY)),
    );
    canvas.drawPath(
      perspectiveTop,
      Paint()
        ..color = const Color(0xFF6BFFF6).withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    canvas.drawLine(
      Offset(w * 0.10, h * 0.80),
      Offset(w * 0.90, h * 0.80),
      Paint()
        ..color = const Color(0xFF6BFFF6).withValues(alpha: 0.18)
        ..strokeWidth = 1,
    );
  }

  void _paintFieldStadium(Canvas canvas, double w, double h) {
    // Ночное небо.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F1B33), Color(0xFF1A2D55), Color(0xFF223C70)],
        ).createShader(Rect.fromLTWH(0, 0, w, h * 0.62)),
    );
    // Прожекторное свечение вокруг ворот.
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.18),
      w * 0.55,
      Paint()
        ..color = const Color(0xFFFFE7B5).withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );
    // Газон — два чередующихся «среза» для эффекта стрижки.
    final groundY = h * 0.62;
    final fieldPath = Path()
      ..moveTo(0, h)
      ..lineTo(w, h)
      ..lineTo(w * 0.82, groundY)
      ..lineTo(w * 0.18, groundY)
      ..close();
    canvas.drawPath(
      fieldPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E5B2A), Color(0xFF2E8540)],
        ).createShader(Rect.fromLTWH(0, groundY, w, h - groundY)),
    );
    // Полоса покоса — затемнённый трапециевидный «слой» в центре.
    final stripe = Path()
      ..moveTo(w * 0.30, h)
      ..lineTo(w * 0.70, h)
      ..lineTo(w * 0.60, groundY)
      ..lineTo(w * 0.40, groundY)
      ..close();
    canvas.drawPath(
      stripe,
      Paint()..color = const Color(0xFF184C24).withValues(alpha: 0.55),
    );

    // Белые линии разметки в перспективе.
    final whiteLine = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Линия ворот (под подошвой) — широкая.
    canvas.drawLine(
      Offset(w * 0.05, groundY + 1),
      Offset(w * 0.95, groundY + 1),
      whiteLine,
    );
    // Боковые штрафной.
    canvas.drawLine(
      Offset(w * 0.10, groundY),
      Offset(w * 0.02, h * 0.96),
      whiteLine,
    );
    canvas.drawLine(
      Offset(w * 0.90, groundY),
      Offset(w * 0.98, h * 0.96),
      whiteLine,
    );
    // Передняя линия штрафной + дуга вратарской.
    canvas.drawLine(
      Offset(w * 0.02, h * 0.96),
      Offset(w * 0.98, h * 0.96),
      whiteLine,
    );
    // Точка пенальти.
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.86),
      3,
      Paint()..color = Colors.white,
    );
  }

  void _paintFieldFlat(Canvas canvas, double w, double h) {
    // Очень мягкий пастельный фон + чистый блок «поля» внизу.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE6D5), Color(0xFFFFD7C2)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    final groundY = h * 0.62;
    final fieldRect = Rect.fromLTWH(0, groundY, w, h - groundY);
    canvas.drawRect(fieldRect, Paint()..color = const Color(0xFF98D9A0));
    // Тонкая, аккуратная разделительная линия.
    canvas.drawLine(
      Offset(0, groundY),
      Offset(w, groundY),
      Paint()
        ..color = const Color(0xFF59489E).withValues(alpha: 0.18)
        ..strokeWidth = 2,
    );
    // Кружок-«точка пенальти» как акцент.
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.86),
      5,
      Paint()..color = const Color(0xFFE6735A),
    );
  }

  void _paintFieldComic(Canvas canvas, double w, double h) {
    // Радиальный «бэкграунд-burst».
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFE940), Color(0xFFFFB300)],
          radius: 0.85,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    // Лучи от центра ворот.
    final centerRay = Offset(w * 0.5, h * 0.4);
    final rayPaint = Paint()..color = const Color(0xFFFFCB2B);
    for (var i = 0; i < 12; i++) {
      final a1 = i * (math.pi * 2 / 12) - 0.07;
      final a2 = a1 + 0.14;
      final r = math.max(w, h) * 1.2;
      final p1 = Offset(
        centerRay.dx + math.cos(a1) * r,
        centerRay.dy + math.sin(a1) * r,
      );
      final p2 = Offset(
        centerRay.dx + math.cos(a2) * r,
        centerRay.dy + math.sin(a2) * r,
      );
      final path = Path()
        ..moveTo(centerRay.dx, centerRay.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();
      canvas.drawPath(path, rayPaint);
    }
    // Поле.
    final groundY = h * 0.62;
    final field = Path()
      ..moveTo(-4, h + 4)
      ..lineTo(w + 4, h + 4)
      ..lineTo(w * 0.82, groundY)
      ..lineTo(w * 0.18, groundY)
      ..close();
    canvas.drawPath(field, Paint()..color = const Color(0xFF6CCB5E));
    canvas.drawPath(
      field,
      Paint()
        ..color = const Color(0xFF111111)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5,
    );
    // Halftone-точки для атмосферы (только в небе).
    final dot = Paint()..color = const Color(0xFF111111).withValues(alpha: 0.18);
    final dotR = math.max(w, h) * 0.006;
    final stepX = w / 16;
    final stepY = h * 0.6 / 12;
    for (var iy = 0; iy < 10; iy++) {
      for (var ix = 0; ix < 16; ix++) {
        final cx = ix * stepX + (iy.isOdd ? stepX / 2 : 0);
        final cy = 8 + iy * stepY;
        if (cy < groundY - 14) {
          canvas.drawCircle(Offset(cx, cy), dotR, dot);
        }
      }
    }
  }

  void _paintGoal(Canvas canvas, double w, double h) {
    switch (style) {
      case MiniGameStyle.cyber:
        _paintGoalCyber(canvas, w, h);
        break;
      case MiniGameStyle.stadium:
        _paintGoalStadium(canvas, w, h);
        break;
      case MiniGameStyle.flat:
        _paintGoalFlat(canvas, w, h);
        break;
      case MiniGameStyle.comic:
        _paintGoalComic(canvas, w, h);
        break;
      case MiniGameStyle.pixel:
        _paintGoalPixel(canvas, w, h);
        break;
      case MiniGameStyle.lowPoly:
        _paintGoalLowPoly(canvas, w, h);
        break;
    }
  }

  void _paintGoalCyber(Canvas canvas, double w, double h) {
    // Передняя рамка ворот.
    final goalLeft = w * 0.18;
    final goalRight = w * 0.82;
    final goalTop = h * 0.18;
    final goalBottom = h * 0.62;

    // Точка схода — за задней стенкой ворот, чтобы получить корректную перспективу.
    final vpX = (goalLeft + goalRight) / 2;
    final vpY = (goalTop + goalBottom) / 2 - (goalBottom - goalTop) * 0.04;
    // Насколько задняя стенка «уходит вглубь» к точке схода.
    const depth = 0.42;

    Offset toBack(Offset front) => Offset(
      front.dx + (vpX - front.dx) * depth,
      front.dy + (vpY - front.dy) * depth,
    );

    // Углы передней рамки.
    final ftl = Offset(goalLeft, goalTop);
    final ftr = Offset(goalRight, goalTop);
    final fbl = Offset(goalLeft, goalBottom);
    final fbr = Offset(goalRight, goalBottom);
    // Углы задней стенки сетки.
    final btl = toBack(ftl);
    final btr = toBack(ftr);
    final bbl = toBack(fbl);
    final bbr = toBack(fbr);

    Offset lerp(Offset a, Offset b, double t) => Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);

    final netLine = Paint()
      ..color = const Color(0xFFB46BFF).withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final netLineSoft = Paint()
      ..color = const Color(0xFFB46BFF).withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    final structLine = Paint()
      ..color = const Color(0xFFB46BFF).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Тёмная заливка задней стенки — добавляет глубины.
    final backPath = Path()
      ..moveTo(btl.dx, btl.dy)
      ..lineTo(btr.dx, btr.dy)
      ..lineTo(bbr.dx, bbr.dy)
      ..lineTo(bbl.dx, bbl.dy)
      ..close();
    canvas.drawPath(
      backPath,
      Paint()..color = const Color(0xFF1A0A3E).withValues(alpha: 0.55),
    );
    // Лёгкая ауreola позади сетки.
    canvas.drawPath(
      backPath,
      Paint()
        ..color = const Color(0xFFB46BFF).withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // Сетка задней стенки.
    const cols = 14;
    const rows = 8;
    for (var i = 1; i < cols; i++) {
      final t = i / cols;
      canvas.drawLine(lerp(btl, btr, t), lerp(bbl, bbr, t), netLineSoft);
    }
    for (var i = 1; i < rows; i++) {
      final t = i / rows;
      canvas.drawLine(lerp(btl, bbl, t), lerp(btr, bbr, t), netLineSoft);
    }

    // Боковые/верхняя/нижняя панели — линии, идущие от передней рамки к задней
    // (создают эффект сетки на «стенках» ворот).
    for (var i = 1; i < cols; i++) {
      final t = i / cols;
      // Верхняя панель.
      canvas.drawLine(lerp(ftl, ftr, t), lerp(btl, btr, t), netLineSoft);
      // Нижняя панель.
      canvas.drawLine(lerp(fbl, fbr, t), lerp(bbl, bbr, t), netLineSoft);
    }
    for (var i = 1; i < rows; i++) {
      final t = i / rows;
      // Левая панель.
      canvas.drawLine(lerp(ftl, fbl, t), lerp(btl, bbl, t), netLineSoft);
      // Правая панель.
      canvas.drawLine(lerp(ftr, fbr, t), lerp(btr, bbr, t), netLineSoft);
    }

    // Структурные «верёвки» по углам и задней рамке.
    canvas.drawLine(ftl, btl, structLine);
    canvas.drawLine(ftr, btr, structLine);
    canvas.drawLine(fbl, bbl, structLine);
    canvas.drawLine(fbr, bbr, structLine);
    canvas.drawLine(btl, btr, netLine);
    canvas.drawLine(btr, bbr, netLine);
    canvas.drawLine(bbr, bbl, netLine);
    canvas.drawLine(bbl, btl, netLine);

    // Передняя рамка — самые яркие неоновые стойки и перекладина.
    final postPaint = Paint()
      ..color = const Color(0xFFF1D6FF)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final postGlow = Paint()
      ..color = const Color(0xFFB46BFF).withValues(alpha: 0.75)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Перекладина.
    canvas.drawLine(ftl, ftr, postGlow);
    canvas.drawLine(ftl, ftr, postPaint);
    // Левая стойка.
    canvas.drawLine(ftl, fbl, postGlow);
    canvas.drawLine(ftl, fbl, postPaint);
    // Правая стойка.
    canvas.drawLine(ftr, fbr, postGlow);
    canvas.drawLine(ftr, fbr, postPaint);

    // Линия земли под воротами (бирюзовая) — стыкуется с перспективой поля.
    canvas.drawLine(
      fbl,
      fbr,
      Paint()
        ..color = const Color(0xFF6BFFF6).withValues(alpha: 0.85)
        ..strokeWidth = 2,
    );
  }

  // Утилита: геометрия ворот в перспективе. Возвращает 8 углов
  // (передняя рамка ftl/ftr/fbl/fbr + задняя btl/btr/bbl/bbr).
  List<Offset> _goalCorners(double w, double h) {
    final gl = w * 0.18;
    final gr = w * 0.82;
    final gt = h * 0.18;
    final gb = h * 0.62;
    final vpX = (gl + gr) / 2;
    final vpY = (gt + gb) / 2 - (gb - gt) * 0.04;
    const depth = 0.42;
    Offset toBack(Offset f) => Offset(f.dx + (vpX - f.dx) * depth, f.dy + (vpY - f.dy) * depth);
    final ftl = Offset(gl, gt);
    final ftr = Offset(gr, gt);
    final fbl = Offset(gl, gb);
    final fbr = Offset(gr, gb);
    return [
      ftl,
      ftr,
      fbl,
      fbr,
      toBack(ftl),
      toBack(ftr),
      toBack(fbl),
      toBack(fbr),
    ];
  }

  void _paintGoalStadium(Canvas canvas, double w, double h) {
    final c = _goalCorners(w, h);
    final ftl = c[0], ftr = c[1], fbl = c[2], fbr = c[3];
    final btl = c[4], btr = c[5], bbl = c[6], bbr = c[7];
    Offset lerp(Offset a, Offset b, double t) => Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);

    // Тёмная подсветка глубины сетки.
    canvas.drawPath(
      Path()
        ..moveTo(btl.dx, btl.dy)
        ..lineTo(btr.dx, btr.dy)
        ..lineTo(bbr.dx, bbr.dy)
        ..lineTo(bbl.dx, bbl.dy)
        ..close(),
      Paint()..color = const Color(0xFF143923).withValues(alpha: 0.85),
    );

    // Сетка — тонкие белые нити.
    final net = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    const cols = 18;
    const rows = 12;
    for (var i = 1; i < cols; i++) {
      final t = i / cols;
      canvas.drawLine(lerp(btl, btr, t), lerp(bbl, bbr, t), net);
      canvas.drawLine(lerp(ftl, ftr, t), lerp(btl, btr, t), net);
      canvas.drawLine(lerp(fbl, fbr, t), lerp(bbl, bbr, t), net);
    }
    for (var i = 1; i < rows; i++) {
      final t = i / rows;
      canvas.drawLine(lerp(btl, bbl, t), lerp(btr, bbr, t), net);
      canvas.drawLine(lerp(ftl, fbl, t), lerp(btl, bbl, t), net);
      canvas.drawLine(lerp(ftr, fbr, t), lerp(btr, bbr, t), net);
    }
    // Углы и задняя рамка.
    final corner = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(ftl, btl, corner);
    canvas.drawLine(ftr, btr, corner);
    canvas.drawLine(fbl, bbl, corner);
    canvas.drawLine(fbr, bbr, corner);
    canvas.drawLine(btl, btr, corner);
    canvas.drawLine(btr, bbr, corner);
    canvas.drawLine(bbr, bbl, corner);
    canvas.drawLine(bbl, btl, corner);

    // Передние стойки и перекладина — белый «металл» с лёгкой тенью.
    final post = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final postShadow = Paint()
      ..color = const Color(0xFF8FA0B8).withValues(alpha: 0.4)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(ftl.translate(2, 2), ftr.translate(2, 2), postShadow);
    canvas.drawLine(ftl.translate(2, 2), fbl.translate(2, 2), postShadow);
    canvas.drawLine(ftr.translate(2, 2), fbr.translate(2, 2), postShadow);
    canvas.drawLine(ftl, ftr, post);
    canvas.drawLine(ftl, fbl, post);
    canvas.drawLine(ftr, fbr, post);
  }

  void _paintGoalFlat(Canvas canvas, double w, double h) {
    final goalLeft = w * 0.18;
    final goalRight = w * 0.82;
    final goalTop = h * 0.20;
    final goalBottom = h * 0.62;
    final rect = Rect.fromLTRB(goalLeft, goalTop, goalRight, goalBottom);

    // Мягкая «заливка» внутри ворот.
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      Paint()..color = const Color(0xFFFFF6E5),
    );

    // Тонкая ненавязчивая сетка из точек.
    final dot = Paint()..color = const Color(0xFF59489E).withValues(alpha: 0.15);
    const cols = 9;
    const rows = 6;
    for (var i = 1; i < cols; i++) {
      for (var j = 1; j < rows; j++) {
        final x = goalLeft + (goalRight - goalLeft) * i / cols;
        final y = goalTop + (goalBottom - goalTop) * j / rows;
        canvas.drawCircle(Offset(x, y), 1.8, dot);
      }
    }

    // Толстая «коралловая» рамка ворот.
    final frame = Paint()
      ..color = const Color(0xFFE6735A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      frame,
    );
  }

  void _paintGoalComic(Canvas canvas, double w, double h) {
    final c = _goalCorners(w, h);
    final ftl = c[0], ftr = c[1], fbl = c[2], fbr = c[3];
    final btl = c[4], btr = c[5], bbl = c[6], bbr = c[7];
    Offset lerp(Offset a, Offset b, double t) => Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);

    // Задняя стенка — белая, с яркой обводкой.
    final backPath = Path()
      ..moveTo(btl.dx, btl.dy)
      ..lineTo(btr.dx, btr.dy)
      ..lineTo(bbr.dx, bbr.dy)
      ..lineTo(bbl.dx, bbl.dy)
      ..close();
    canvas.drawPath(backPath, Paint()..color = const Color(0xFFFFF8E0));
    // Толстая стилизованная сетка.
    final mesh = Paint()
      ..color = const Color(0xFF111111).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    const cols = 8;
    const rows = 5;
    for (var i = 1; i < cols; i++) {
      final t = i / cols;
      canvas.drawLine(lerp(btl, btr, t), lerp(bbl, bbr, t), mesh);
    }
    for (var i = 1; i < rows; i++) {
      final t = i / rows;
      canvas.drawLine(lerp(btl, bbl, t), lerp(btr, bbr, t), mesh);
    }

    // Угловые «верёвки».
    final rope = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawLine(ftl, btl, rope);
    canvas.drawLine(ftr, btr, rope);
    canvas.drawLine(fbl, bbl, rope);
    canvas.drawLine(fbr, bbr, rope);
    canvas.drawLine(btl, btr, rope);
    canvas.drawLine(btr, bbr, rope);
    canvas.drawLine(bbr, bbl, rope);
    canvas.drawLine(bbl, btl, rope);

    // Передняя рамка — толстая, чёрная обводка + красный «контур».
    final frameOuter = Paint()
      ..color = const Color(0xFF111111)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final frameInner = Paint()
      ..color = const Color(0xFFFF4F58)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(ftl, ftr, frameOuter);
    canvas.drawLine(ftl, fbl, frameOuter);
    canvas.drawLine(ftr, fbr, frameOuter);
    canvas.drawLine(ftl, ftr, frameInner);
    canvas.drawLine(ftl, fbl, frameInner);
    canvas.drawLine(ftr, fbr, frameInner);
  }

  // === PIXEL ART ============================================================

  // Размер одного «пикселя» в текущем кадре.
  double _pixelUnit(double w, double h) => math.max(2.0, math.min(w, h) * 0.012);

  void _paintFieldPixel(Canvas canvas, double w, double h) {
    final px = _pixelUnit(w, h);
    // Чанковое небо — закат: ряды-полосы разных оттенков.
    final bands = [
      const Color(0xFF1B0C3A),
      const Color(0xFF3B1666),
      const Color(0xFF6E2A6E),
      const Color(0xFFA13D6B),
      const Color(0xFFD75462),
      const Color(0xFFFF8856),
      const Color(0xFFFFB347),
    ];
    final bandHeight = (h * 0.6) / bands.length;
    for (var i = 0; i < bands.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * bandHeight, w, bandHeight + 0.5),
        Paint()..color = bands[i],
      );
    }
    // Дитеринг — точки на стыке полос.
    final dither = Paint()..color = Colors.white.withValues(alpha: 0.05);
    for (var i = 1; i < bands.length; i++) {
      final y = i * bandHeight;
      for (var x = 0; x < w; x += (px * 2).toInt()) {
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y - px, px, px), dither);
      }
    }

    // «Газон» — пиксельная сетка из чередующихся зелёных оттенков.
    final groundY = h * 0.6;
    const groundDark = Color(0xFF1F6B36);
    const groundLight = Color(0xFF2E8F4A);
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, w, h - groundY),
      Paint()..color = groundDark,
    );
    final tile = px * 4;
    for (double y = groundY; y < h; y += tile) {
      for (double x = 0; x < w; x += tile) {
        final r = ((y - groundY) / tile + x / tile).floor();
        if (r.isEven) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, tile, tile),
            Paint()..color = groundLight,
          );
        }
      }
    }
  }

  void _paintGoalPixel(Canvas canvas, double w, double h) {
    final px = _pixelUnit(w, h);
    final goalLeft = (w * 0.18 / px).round() * px;
    final goalRight = (w * 0.82 / px).round() * px;
    final goalTop = (h * 0.20 / px).round() * px;
    final goalBottom = (h * 0.62 / px).round() * px;

    // Задняя стенка (затемнённое поле «внутри» ворот).
    canvas.drawRect(
      Rect.fromLTRB(goalLeft, goalTop, goalRight, goalBottom),
      Paint()..color = const Color(0xFF14082A),
    );

    // Пиксельная сетка — крупные ячейки.
    final cell = px * 3;
    final netPaint = Paint()..color = Colors.white.withValues(alpha: 0.32);
    for (double x = goalLeft + cell; x < goalRight; x += cell) {
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          goalTop,
          math.max(1.0, px * 0.5),
          goalBottom - goalTop,
        ),
        netPaint,
      );
    }
    for (double y = goalTop + cell; y < goalBottom; y += cell) {
      canvas.drawRect(
        Rect.fromLTWH(
          goalLeft,
          y,
          goalRight - goalLeft,
          math.max(1.0, px * 0.5),
        ),
        netPaint,
      );
    }

    // Толстые «пиксельные» стойки и перекладина.
    final post = Paint()..color = const Color(0xFFFFE066);
    final postShadow = Paint()..color = const Color(0xFFB89230);
    canvas.drawRect(
      Rect.fromLTWH(
        goalLeft - px * 2,
        goalTop - px * 2,
        px * 2,
        goalBottom - goalTop + px * 4,
      ),
      post,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        goalRight,
        goalTop - px * 2,
        px * 2,
        goalBottom - goalTop + px * 4,
      ),
      post,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        goalLeft - px * 2,
        goalTop - px * 2,
        goalRight - goalLeft + px * 4,
        px * 2,
      ),
      post,
    );
    // Чуть более тёмный «низ» перекладины — pixel art shadow.
    canvas.drawRect(
      Rect.fromLTWH(
        goalLeft - px * 2,
        goalTop,
        goalRight - goalLeft + px * 4,
        px,
      ),
      postShadow,
    );
  }

  // === LOW-POLY =============================================================

  void _paintFieldLowPoly(Canvas canvas, double w, double h) {
    // Небо.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF274060), Color(0xFF6D9DC5), Color(0xFFAACCE0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Дальние горы — низкополигональный силуэт.
    const mountainFar = Color(0xFF4E6A8E);
    const mountainNear = Color(0xFF3D567A);
    final mountainPath = Path()..moveTo(0, h * 0.50);
    final peaks = [
      Offset(w * 0.10, h * 0.42),
      Offset(w * 0.22, h * 0.50),
      Offset(w * 0.35, h * 0.38),
      Offset(w * 0.50, h * 0.50),
      Offset(w * 0.65, h * 0.36),
      Offset(w * 0.78, h * 0.48),
      Offset(w * 0.92, h * 0.40),
    ];
    for (final p in peaks) {
      mountainPath.lineTo(p.dx, p.dy);
    }
    mountainPath
      ..lineTo(w, h * 0.50)
      ..lineTo(w, h * 0.62)
      ..lineTo(0, h * 0.62)
      ..close();
    canvas.drawPath(mountainPath, Paint()..color = mountainFar);

    // Передний хребет — на 1 пик ближе.
    final ridgePath = Path()..moveTo(0, h * 0.56);
    final ridgePeaks = [
      Offset(w * 0.18, h * 0.48),
      Offset(w * 0.38, h * 0.54),
      Offset(w * 0.58, h * 0.46),
      Offset(w * 0.82, h * 0.55),
    ];
    for (final p in ridgePeaks) {
      ridgePath.lineTo(p.dx, p.dy);
    }
    ridgePath
      ..lineTo(w, h * 0.56)
      ..lineTo(w, h * 0.62)
      ..lineTo(0, h * 0.62)
      ..close();
    canvas.drawPath(ridgePath, Paint()..color = mountainNear);

    // Поле — фасетка из треугольников.
    final groundY = h * 0.62;
    final tileW = w / 6;
    final tileH = (h - groundY) / 4;
    const greenA = Color(0xFF5BAE5C);
    const greenB = Color(0xFF4A9C4B);
    const greenC = Color(0xFF6BBE6C);
    for (var iy = 0; iy < 4; iy++) {
      for (var ix = 0; ix < 6; ix++) {
        final x0 = ix * tileW;
        final y0 = groundY + iy * tileH;
        final p1 = Path()
          ..moveTo(x0, y0)
          ..lineTo(x0 + tileW, y0)
          ..lineTo(x0 + tileW, y0 + tileH)
          ..close();
        final p2 = Path()
          ..moveTo(x0, y0)
          ..lineTo(x0, y0 + tileH)
          ..lineTo(x0 + tileW, y0 + tileH)
          ..close();
        final pick = (ix + iy) % 3;
        canvas.drawPath(
          p1,
          Paint()
            ..color = [greenA, greenB, greenC][pick]
            ..isAntiAlias = true,
        );
        canvas.drawPath(
          p2,
          Paint()
            ..color = [greenB, greenC, greenA][pick]
            ..isAntiAlias = true,
        );
      }
    }
  }

  void _paintGoalLowPoly(Canvas canvas, double w, double h) {
    final c = _goalCorners(w, h);
    final ftl = c[0], ftr = c[1], fbl = c[2], fbr = c[3];
    final btl = c[4], btr = c[5], bbl = c[6], bbr = c[7];

    // Внутренний объём ворот — три низкополигональные плоскости с разной тенью.
    // Задняя стенка — самая тёмная.
    canvas.drawPath(
      Path()
        ..moveTo(btl.dx, btl.dy)
        ..lineTo(btr.dx, btr.dy)
        ..lineTo(bbr.dx, bbr.dy)
        ..lineTo(bbl.dx, bbl.dy)
        ..close(),
      Paint()..color = const Color(0xFF1B2A40),
    );
    // Верхняя.
    canvas.drawPath(
      Path()
        ..moveTo(ftl.dx, ftl.dy)
        ..lineTo(ftr.dx, ftr.dy)
        ..lineTo(btr.dx, btr.dy)
        ..lineTo(btl.dx, btl.dy)
        ..close(),
      Paint()..color = const Color(0xFF263A57),
    );
    // Левая.
    canvas.drawPath(
      Path()
        ..moveTo(ftl.dx, ftl.dy)
        ..lineTo(btl.dx, btl.dy)
        ..lineTo(bbl.dx, bbl.dy)
        ..lineTo(fbl.dx, fbl.dy)
        ..close(),
      Paint()..color = const Color(0xFF22344E),
    );
    // Правая.
    canvas.drawPath(
      Path()
        ..moveTo(ftr.dx, ftr.dy)
        ..lineTo(btr.dx, btr.dy)
        ..lineTo(bbr.dx, bbr.dy)
        ..lineTo(fbr.dx, fbr.dy)
        ..close(),
      Paint()..color = const Color(0xFF1F3047),
    );
    // Нижняя — светлее, как «пол ворот».
    canvas.drawPath(
      Path()
        ..moveTo(fbl.dx, fbl.dy)
        ..lineTo(fbr.dx, fbr.dy)
        ..lineTo(bbr.dx, bbr.dy)
        ..lineTo(bbl.dx, bbl.dy)
        ..close(),
      Paint()..color = const Color(0xFF2C4768),
    );

    // Треугольные «грани» рамки — фасет даёт low-poly look.
    const frameColor = Color(0xFFFFD56B);
    const frameShade = Color(0xFFCD9B30);
    final frameThickness = (math.min(w, h) * 0.018).clamp(4.0, 12.0).toDouble();
    void drawFaceted(Offset a, Offset b) {
      final dir = b - a;
      final len = dir.distance;
      if (len < 1) return;
      final nx = -dir.dy / len * frameThickness * 0.5;
      final ny = dir.dx / len * frameThickness * 0.5;
      final p1 = Offset(a.dx + nx, a.dy + ny);
      final p2 = Offset(b.dx + nx, b.dy + ny);
      final p3 = Offset(b.dx - nx, b.dy - ny);
      final p4 = Offset(a.dx - nx, a.dy - ny);
      final top = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(a.dx, a.dy)
        ..close();
      final bot = Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(p3.dx, p3.dy)
        ..lineTo(p4.dx, p4.dy)
        ..close();
      canvas.drawPath(top, Paint()..color = frameColor);
      canvas.drawPath(bot, Paint()..color = frameShade);
    }

    drawFaceted(ftl, ftr); // перекладина
    drawFaceted(ftl, fbl); // левая
    drawFaceted(ftr, fbr); // правая

    // Тонкие линии задней рамки — закрепляют перспективу.
    final back = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(btl, btr, back);
    canvas.drawLine(btr, bbr, back);
    canvas.drawLine(bbr, bbl, back);
    canvas.drawLine(bbl, btl, back);
  }

  void _paintKeeper(Canvas canvas, double w, double h) {
    if (style == MiniGameStyle.pixel) {
      _paintKeeperPixel(canvas, w, h);
      return;
    }
    final goalTop = h * 0.18;
    final goalBottom = h * 0.62;
    final goalHeight = goalBottom - goalTop;
    final cx = w * _keeperX;

    final idle = _keeperIdleSprite;
    if (idle == null) {
      _paintKeeperFallback(canvas, w, h, cx, goalTop, goalBottom);
      return;
    }

    final active = _state != _MiniShotState.aiming;
    final progress = active ? (_state == _MiniShotState.flying ? _shotProgress : 1.0).clamp(0.0, 1.0).toDouble() : 0.0;

    ui.Image sprite;
    bool flipX = false;
    double drawHeight;
    Offset center;

    if (active && _diveDirection != 0 && progress > 0.18) {
      sprite = switch (_diveStyle) {
        _KeeperDive.low => _keeperDiveLowSprite ?? _keeperDiveMidSprite ?? idle,
        _KeeperDive.mid => _keeperDiveMidSprite ?? idle,
        _KeeperDive.high => _keeperDiveHighSprite ?? _keeperDiveMidSprite ?? idle,
      };
      flipX = _diveDirection > 0; // спрайты — прыжок влево, флипаем для правого
      drawHeight = goalHeight * 0.58;
      final eased = _easeOutCubic((progress - 0.18) / 0.82);
      final reachX = w * _keeperTargetX;
      final destX = cx + (reachX - cx) * eased;
      final altByStyle = switch (_diveStyle) {
        _KeeperDive.low => -goalHeight * 0.05,
        _KeeperDive.mid => -goalHeight * 0.18,
        _KeeperDive.high => -goalHeight * 0.34,
      };
      final destY = goalBottom - goalHeight * 0.30 + altByStyle * eased;
      center = Offset(destX, destY);
    } else {
      sprite = idle;
      // При движении к прыжку небольшая «подготовка» — лёгкий присед.
      final prep = active ? _smoothStep(progress / 0.18) : 0.0;
      drawHeight = goalHeight * (0.82 - prep * 0.04);
      final footY = goalBottom - goalHeight * 0.04;
      center = Offset(cx, footY - drawHeight / 2);
    }

    final spriteAspect = sprite.width / sprite.height;
    final drawWidth = drawHeight * spriteAspect;

    // Подсвечивающий хало позади вратаря — цвет зависит от темы.
    final pal = _palette;
    if (pal.keeperHaloPrimary.a > 0) {
      canvas.drawCircle(
        center.translate(0, -drawHeight * 0.05),
        drawWidth * 0.46,
        Paint()
          ..color = pal.keeperHaloPrimary.withValues(alpha: 0.32)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
      );
    }
    if (pal.keeperHaloSecondary.a > 0) {
      canvas.drawCircle(
        center.translate(0, -drawHeight * 0.05),
        drawWidth * 0.28,
        Paint()
          ..color = pal.keeperHaloSecondary.withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );
    }

    // Тень под спрайтом — приклеена к нижней линии ворот.
    final shadowWidth = drawWidth * (active && _diveDirection != 0 ? 0.85 : 0.6);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, goalBottom - 2),
        width: shadowWidth,
        height: 10,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.38)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Сам спрайт.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (flipX) {
      canvas.scale(-1, 1);
    }
    final dst = Rect.fromCenter(
      center: Offset.zero,
      width: drawWidth,
      height: drawHeight,
    );
    canvas.drawImageRect(
      sprite,
      Rect.fromLTWH(0, 0, sprite.width.toDouble(), sprite.height.toDouble()),
      dst,
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();
  }

  // Процедурный пиксельный вратарь. Idle — стоящая фигура, dive — горизонтальная
  // с вытянутыми руками. Спрайт мы не используем — рисуем квадратиками.
  static const List<String> _pixelIdle = [
    '............',
    '....HHHH....',
    '...HSSSSH...',
    '...HSSSSH...',
    '....SSSS....',
    '.GYYYYYYYYG.',
    '..YYYYYYYY..',
    '...YYYYYY...',
    '...YYYYYY...',
    '...PPPPPP...',
    '...PPPPPP...',
    '...PP..PP...',
    '...YY..YY...',
    '...BB..BB...',
  ];

  static const List<String> _pixelDive = [
    '.GG..............',
    'GGYYYYY.....HHHH.',
    '.YYYYYYYY..HSSSSH',
    '..YYYYYYYYY.SSSS.',
    '..PPPPPPYYY..PP..',
    '.YY..PPPYYY......',
    '.BB...YY..BB.....',
    '.......BB........',
  ];

  static const Map<String, Color> _pixelPalette = {
    'H': Color(0xFF2B1A12),
    'S': Color(0xFFF1BE91),
    'Y': Color(0xFFFFCC33),
    'P': Color(0xFFE6A500),
    'G': Color(0xFFF5F5F5),
    'B': Color(0xFF1B1B1B),
  };

  void _paintKeeperPixel(Canvas canvas, double w, double h) {
    final goalTop = h * 0.20;
    final goalBottom = h * 0.62;
    final goalHeight = goalBottom - goalTop;
    final cx = w * _keeperX;

    final active = _state != _MiniShotState.aiming;
    final progress = active ? (_state == _MiniShotState.flying ? _shotProgress : 1.0).clamp(0.0, 1.0).toDouble() : 0.0;

    List<String> sprite;
    bool flipX = false;
    double targetCenterX = cx;
    double targetCenterY;
    double scale;

    if (active && _diveDirection != 0 && progress > 0.18) {
      sprite = _pixelDive;
      flipX = _diveDirection > 0;
      // Размер пикселя: dive шире — оптимизируем под высоту прыжка.
      scale = goalHeight * 0.34 / sprite.length;
      final eased = _easeOutCubic((progress - 0.18) / 0.82);
      final reachX = w * _keeperTargetX;
      targetCenterX = cx + (reachX - cx) * eased;
      final altByStyle = switch (_diveStyle) {
        _KeeperDive.low => -goalHeight * 0.04,
        _KeeperDive.mid => -goalHeight * 0.16,
        _KeeperDive.high => -goalHeight * 0.30,
      };
      targetCenterY = goalBottom - goalHeight * 0.22 + altByStyle * eased;
    } else {
      sprite = _pixelIdle;
      scale = goalHeight * 0.78 / sprite.length;
      final footY = goalBottom - goalHeight * 0.02;
      targetCenterY = footY - (sprite.length * scale) / 2;
    }

    final cols = sprite[0].length;
    final rows = sprite.length;
    final originX = targetCenterX - cols * scale / 2;
    final originY = targetCenterY - rows * scale / 2;

    // Тень-«стелька» под фигурой.
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(targetCenterX, goalBottom),
        width: cols * scale * 0.7,
        height: scale * 1.5,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );

    final paintCache = <String, Paint>{};
    for (var y = 0; y < rows; y++) {
      final row = sprite[y];
      for (var x = 0; x < cols; x++) {
        final ch = row[x];
        if (ch == '.') continue;
        final color = _pixelPalette[ch];
        if (color == null) continue;
        final paint = paintCache.putIfAbsent(ch, () => Paint()..color = color);
        final drawX = flipX ? cols - 1 - x : x;
        canvas.drawRect(
          Rect.fromLTWH(
            originX + drawX * scale,
            originY + y * scale,
            scale + 0.6,
            scale + 0.6,
          ),
          paint,
        );
      }
    }
  }

  void _paintKeeperFallback(
    Canvas canvas,
    double w,
    double h,
    double cx,
    double goalTop,
    double goalBottom,
  ) {
    final keeperY = goalBottom - (goalBottom - goalTop) * 0.18;
    final keeperWidth = w * (_keeperReach * 0.95);
    final keeperHeight = (goalBottom - goalTop) * 0.55;

    final body = Rect.fromCenter(
      center: Offset(cx, keeperY),
      width: keeperWidth,
      height: keeperHeight,
    );
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF6BD6), Color(0xFF6B5BFF)],
      ).createShader(body);
    final glow = Paint()
      ..color = const Color(0xFFFF6BD6).withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final rrect = RRect.fromRectAndRadius(body, const Radius.circular(8));
    canvas.drawRRect(rrect, glow);
    canvas.drawRRect(rrect, paint);

    final headRadius = keeperWidth * 0.25;
    canvas.drawCircle(
      Offset(cx, body.top - headRadius * 0.4),
      headRadius,
      Paint()..color = const Color(0xFFFFE0F5),
    );
  }

  void _paintBall(Canvas canvas, double w, double h) {
    final pal = _palette;
    final cx = w * _ballPos.x;
    final cy = h * _ballPos.y;
    final base = math.min(w, h) * 0.028;
    final radius = _state == _MiniShotState.flying ? base * (1 + math.sin(_shotProgress * math.pi) * 0.35) : base;
    // Тень под мячом.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h * 0.92),
        width: radius * 2.4,
        height: radius * 0.7,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );

    if (style == MiniGameStyle.pixel) {
      _paintBallPixel(canvas, cx, cy, radius, pal);
      return;
    }
    if (style == MiniGameStyle.lowPoly) {
      _paintBallLowPoly(canvas, cx, cy, radius);
      return;
    }

    // Свечение (если у темы оно есть).
    if (pal.ballGlow.a > 0) {
      canvas.drawCircle(
        Offset(cx, cy),
        radius * 1.8,
        Paint()
          ..color = pal.ballGlow.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
    // Комикс: толстая чёрная обводка вокруг мяча.
    if (style == MiniGameStyle.comic) {
      canvas.drawCircle(
        Offset(cx, cy),
        radius + 1.6,
        Paint()..color = const Color(0xFF111111),
      );
    }
    canvas.drawCircle(Offset(cx, cy), radius, Paint()..color = pal.ballFill);
    // Шесть «пятен» на мяче. В flat — одна точка, в комиксе — крупнее.
    final spot = Paint()..color = pal.ballSpot;
    if (style == MiniGameStyle.flat) {
      canvas.drawCircle(Offset(cx, cy), radius * 0.28, spot);
    } else {
      final spotCount = style == MiniGameStyle.comic ? 5 : 5;
      final spotSize = style == MiniGameStyle.comic ? 0.24 : 0.18;
      for (var i = 0; i < spotCount; i++) {
        final angle = i * (math.pi * 2 / spotCount) + _shotProgress * 6.0;
        final dx = math.cos(angle) * radius * 0.45;
        final dy = math.sin(angle) * radius * 0.45;
        canvas.drawCircle(Offset(cx + dx, cy + dy), radius * spotSize, spot);
      }
    }
  }

  // Чанковый «pixel» мяч: 7×7 матрица из квадратиков, ~круг.
  static const List<String> _pixelBall = [
    '..XXX..',
    '.XWWWX.',
    'XWWBWWX',
    'XWBWBWX',
    'XWWBWWX',
    '.XWWWX.',
    '..XXX..',
  ];

  void _paintBallPixel(
    Canvas canvas,
    double cx,
    double cy,
    double radius,
    _MiniPalette pal,
  ) {
    final cell = (radius * 2) / 6;
    final originX = cx - 7 * cell / 2;
    final originY = cy - 7 * cell / 2;
    final whitePaint = Paint()..color = pal.ballFill;
    final blackPaint = Paint()..color = pal.ballSpot;
    final outline = Paint()..color = const Color(0xFF1B1B2A);
    for (var y = 0; y < _pixelBall.length; y++) {
      final row = _pixelBall[y];
      for (var x = 0; x < row.length; x++) {
        final ch = row[x];
        if (ch == '.') continue;
        final paint = switch (ch) {
          'X' => outline,
          'W' => whitePaint,
          'B' => blackPaint,
          _ => whitePaint,
        };
        canvas.drawRect(
          Rect.fromLTWH(
            originX + x * cell,
            originY + y * cell,
            cell + 0.6,
            cell + 0.6,
          ),
          paint,
        );
      }
    }
  }

  void _paintBallLowPoly(Canvas canvas, double cx, double cy, double radius) {
    // Мяч как набор треугольных граней с легким градиентом.
    const sides = 7;
    final base = Offset(cx, cy);
    final colors = [
      const Color(0xFFFFFFFF),
      const Color(0xFFE6EAF1),
      const Color(0xFFCFD6E1),
      const Color(0xFFB5BFCC),
    ];
    final spin = _shotProgress * 4 + _hintPhase * 0.4;
    for (var i = 0; i < sides; i++) {
      final a1 = i * (math.pi * 2 / sides) + spin;
      final a2 = (i + 1) * (math.pi * 2 / sides) + spin;
      final p1 = Offset(
        base.dx + math.cos(a1) * radius,
        base.dy + math.sin(a1) * radius,
      );
      final p2 = Offset(
        base.dx + math.cos(a2) * radius,
        base.dy + math.sin(a2) * radius,
      );
      final path = Path()
        ..moveTo(base.dx, base.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = colors[i % colors.length]);
    }
    // Тёмный «нижний» полуовал — мягкая тень-объём.
    canvas.drawArc(
      Rect.fromCircle(center: base, radius: radius),
      math.pi * 0.1,
      math.pi * 0.8,
      true,
      Paint()..color = const Color(0xFF24304B).withValues(alpha: 0.18),
    );
    // Контрастный пиксель-блик.
    canvas.drawCircle(
      Offset(cx - radius * 0.3, cy - radius * 0.35),
      radius * 0.18,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _paintSwipeHint(Canvas canvas, double w, double h) {
    if (_state != _MiniShotState.aiming || _dragStart != null) return;
    final pal = _palette;
    final hint = pal.hintColor;
    final cx = w * 0.5;
    final cy = h * 0.93;
    final pulse = (math.sin(_hintPhase * 3) + 1) / 2;
    final radius = 18 + pulse * 6;
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = hint.withValues(alpha: 0.22 + pulse * 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = style == MiniGameStyle.comic ? 3 : 2,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: 'Swipe',
        style: TextStyle(
          color: hint,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width - 26, cy - tp.height / 2));
    final arrow = Paint()
      ..color = hint
      ..strokeWidth = style == MiniGameStyle.comic ? 3 : 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 4, cy + 4), Offset(cx + 4, cy - 4), arrow);
    canvas.drawLine(Offset(cx + 4, cy - 4), Offset(cx, cy - 4), arrow);
    canvas.drawLine(Offset(cx + 4, cy - 4), Offset(cx + 4, cy), arrow);
  }

  void _paintAimPreview(Canvas canvas, double w, double h) {
    final start = _dragStart;
    final end = _dragCurrent;
    if (start == null || end == null) return;
    if (_state != _MiniShotState.aiming) return;
    final delta = end - start;
    if (delta.dy > -10) return;
    final swipeNorm = (-delta.dy / h).clamp(0.15, 1.2);
    final aimDx = (delta.dx / (w * 0.5)).clamp(-1.1, 1.1).toDouble();
    final targetX = (0.5 + aimDx * 0.32).clamp(0.18, 0.82).toDouble();
    final tx = w * targetX;
    final ty = h * 0.26;
    final bx = w * _ballPos.x;
    final by = h * _ballPos.y;
    final arcHeight = 0.18 + swipeNorm * 0.06;
    final path = Path()..moveTo(bx, by);
    for (var i = 1; i <= 24; i++) {
      final t = i / 24.0;
      final px = bx + (tx - bx) * t;
      final py = by + (ty - by) * t - math.sin(t * math.pi) * h * arcHeight;
      path.lineTo(px, py);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _palette.aimPreview.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = style == MiniGameStyle.comic ? 3.2 : 2.4,
    );
  }

  void _paintResultBanner(Canvas canvas, double w, double h) {
    final pal = _palette;
    String? text;
    Color color;
    switch (_state) {
      case _MiniShotState.goal:
        text = 'GOAL!';
        color = pal.goalBannerColor;
        break;
      case _MiniShotState.saved:
        text = 'SAVED';
        color = pal.saveBannerColor;
        break;
      case _MiniShotState.missed:
        text = 'MISS';
        color = pal.missBannerColor;
        break;
      case _MiniShotState.aiming:
      case _MiniShotState.flying:
        return;
    }
    final alpha = (1 - (_resultTime / 1.4).clamp(0.0, 1.0)).toDouble();
    // Комикс: толстая чёрная обводка вокруг текста.
    if (style == MiniGameStyle.comic) {
      final outline = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 7
              ..color = Colors.black.withValues(alpha: alpha),
            fontSize: 44,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      outline.paint(canvas, Offset((w - outline.width) / 2, h * 0.44));
    }
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withValues(alpha: alpha),
          fontSize: style == MiniGameStyle.comic ? 44 : 36,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(
        (w - tp.width) / 2,
        h * (style == MiniGameStyle.comic ? 0.44 : 0.46),
      ),
    );
  }
}
