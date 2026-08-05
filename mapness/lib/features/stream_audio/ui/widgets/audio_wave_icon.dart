import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class AudioWaveIcon extends ConsumerStatefulWidget {
  final double size;
  final Color? backgroundColor;
  final Color? waveColor;
  final int waveCount;
  final bool showBackground;

  const AudioWaveIcon({
    Key? key,
    this.size = 60.0,
    this.backgroundColor,
    this.waveColor,
    this.waveCount = 6,
    this.showBackground = true,
  }) : super(key: key);

  @override
  ConsumerState<AudioWaveIcon> createState() => _AudioWaveIconState();
}

class _AudioWaveIconState extends ConsumerState<AudioWaveIcon> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _waveControllers;
  bool _isPlaying = false;
  bool _isExited = true;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Individual wave controllers with different durations
    _waveControllers = List.generate(
      widget.waveCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      ),
    );
  }

  void _updateAnimation(bool isPlaying, bool isExited) {
    if (_isPlaying != isPlaying || _isExited != isExited) {
      setState(() {
        _isPlaying = isPlaying;
        _isExited = isExited;
      });

      // Only animate if not exited and playing
      if (!isExited && isPlaying) {
        _startWaveAnimation();
      } else {
        _stopWaveAnimation();
      }
    }
  }

  void _startWaveAnimation() {
    _animationController.repeat();
    for (final controller in _waveControllers) {
      controller.repeat();
    }
  }

  void _stopWaveAnimation() {
    _animationController.stop();
    for (final controller in _waveControllers) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _waveControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final theme = context.streamAudioColors;
    final gradientStart = widget.waveColor ?? theme.waveGradientStart;
    final gradientEnd = theme.waveGradientEnd;

    // Update animation based on provider state
    _updateAnimation(provider.isPlaying, provider.isExited);

    final waveWidget = CustomPaint(
      size: Size(widget.size * 0.6, widget.size * 0.6),
      painter: AudioWavePainter(
        waveControllers: _waveControllers,
        gradientStart: gradientStart,
        gradientEnd: gradientEnd,
        isPlaying: _isPlaying && !_isExited,
      ),
    );

    if (widget.showBackground) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(child: waveWidget),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(child: waveWidget),
    );
  }
}

class AudioWavePainter extends CustomPainter {
  final List<AnimationController> waveControllers;
  final Color gradientStart;
  final Color gradientEnd;
  final bool isPlaying;

  AudioWavePainter({
    required this.waveControllers,
    required this.gradientStart,
    required this.gradientEnd,
    required this.isPlaying,
  }) : super(repaint: Listenable.merge(waveControllers));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final waveWidth = size.width / (waveControllers.length * 1.5 + 0.5);

    // Define base heights for each bar (matching SVG pattern)
    // SVG pattern: short, tall, medium, tallest, medium, shortest
    final baseHeights = [0.33, 0.78, 0.56, 1.0, 0.56, 0.22];

    for (int i = 0; i < waveControllers.length; i++) {
      final controller = waveControllers[i];

      // Calculate wave height based on animation and position
      double waveHeight;
      // Use modulo to safely access baseHeights array for any waveCount
      final baseHeightIndex = i % baseHeights.length;

      if (isPlaying) {
        // Create different wave patterns for each bar
        final animationValue = controller.value;
        final sineWave = math.sin(animationValue * 2 * math.pi);
        final heightMultiplier = 0.7 + (0.3 * (sineWave.abs()));
        waveHeight = size.height * baseHeights[baseHeightIndex] * heightMultiplier;
      } else {
        // Static height when not playing (reduced base height)
        waveHeight = size.height * baseHeights[baseHeightIndex] * 0.6;
      }

      final left = center.dx - (waveControllers.length * waveWidth / 2) + (i * waveWidth) + (waveWidth * 0.25);
      final right = left + (waveWidth * 0.5);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, center.dy - waveHeight / 2, right, center.dy + waveHeight / 2),
        Radius.circular(waveWidth * 0.25),
      );

      // Figma linear gradient: #47CD89 → #079455
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientStart, gradientEnd],
        stops: const [0.298, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect.outerRect)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
