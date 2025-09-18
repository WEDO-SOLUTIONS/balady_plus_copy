import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class ModernAudioProgressBar extends ConsumerStatefulWidget {
  final VoidCallback? onGoLive;

  const ModernAudioProgressBar({
    Key? key,
    this.onGoLive,
  }) : super(key: key);

  @override
  ConsumerState<ModernAudioProgressBar> createState() => _ModernAudioProgressBarState();
}

class _ModernAudioProgressBarState extends ConsumerState<ModernAudioProgressBar>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  bool _showThumb = false;
  double _dragProgress = 0.0;

  late AnimationController _thumbAnimationController;
  late Animation<double> _thumbScaleAnimation;

  @override
  void initState() {
    super.initState();
    _thumbAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _thumbScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _thumbAnimationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _thumbAnimationController.dispose();
    super.dispose();
  }

  void _showThumbIndicator() {
    setState(() {
      _showThumb = true;
    });
    _thumbAnimationController.forward();
  }

  void _hideThumbIndicator() {
    _thumbAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showThumb = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final displayProgress = _isDragging ? _dragProgress : provider.progress;
    final isLive = provider.isLive && !_isDragging;
    final timeBehind = provider.bufferedDuration - provider.currentPosition;
    final showBehind = !isLive && timeBehind.inSeconds > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Time indicators row
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Current time
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: _isDragging
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                  child: Text(
                    _isDragging
                        ? _formatDuration(Duration(
                        milliseconds: (provider.bufferedDuration.inMilliseconds * _dragProgress).round()
                    ))
                        : provider.formattedCurrentPosition,
                  ),
                ),

                const Spacer(),

                // Behind status or Live indicator
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: showBehind
                      ? Container(
                    key: const ValueKey('behind'),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          'Behind ${_formatTimeBehind(timeBehind)}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(key: ValueKey('empty')),
                ),

                // Go Live button
                const SizedBox(width: 8),
                AnimatedOpacity(
                  opacity: !isLive ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: !isLive ? () {
                      ref.read(streamAudioProvider).goLive();
                      widget.onGoLive?.call();
                    } : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.5),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Go LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Total buffered time
                Text(
                  provider.formattedBufferedDuration,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          // Modern progress bar with sharp edges
          GestureDetector(
            onPanStart: (details) {
              _showThumbIndicator();
              setState(() {
                _isDragging = true;
                _dragProgress = _calculateProgress(details.localPosition.dx);
              });
            },
            onPanUpdate: (details) {
              if (_isDragging) {
                setState(() {
                  _dragProgress = _calculateProgress(details.localPosition.dx);
                });
              }
            },
            onPanEnd: (details) {
              if (_isDragging) {
                if (_dragProgress >= 0.98) {
                  ref.read(streamAudioProvider).goLive();
                  widget.onGoLive?.call();
                } else {
                  ref.read(streamAudioProvider).seekToProgress(_dragProgress);
                }
                setState(() {
                  _isDragging = false;
                });
                _hideThumbIndicator();
              }
            },
            onTapDown: (details) {
              _showThumbIndicator();
              final progress = _calculateProgress(details.localPosition.dx);

              if (progress >= 0.98) {
                ref.read(streamAudioProvider).goLive();
                widget.onGoLive?.call();
              } else {
                ref.read(streamAudioProvider).seekToProgress(progress);
              }

              Future.delayed(const Duration(milliseconds: 100), () {
                _hideThumbIndicator();
              });
            },
            child: Container(
              height: 24,
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background track - sharp edges
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),

                  // Buffered portion
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),

                  // Played portion with animation
                  AnimatedContainer(
                    duration: _isDragging
                        ? Duration.zero
                        : const Duration(milliseconds: 100),
                    width: MediaQuery.of(context).size.width * displayProgress,
                    height: 2,
                    decoration: BoxDecoration(
                      color: isLive ? Colors.red : Colors.white,
                    ),
                  ),

                  // Thumb indicator - only shows when interacting
                  if (_showThumb)
                    Positioned(
                      left: (MediaQuery.of(context).size.width - 40) * displayProgress - 6,
                      top: -5,
                      child: ScaleTransition(
                        scale: _thumbScaleAnimation,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress(double localX) {
    final screenWidth = MediaQuery.of(context).size.width - 40; // Account for padding
    final progress = localX / screenWidth;
    return progress.clamp(0.0, 1.0);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  String _formatTimeBehind(Duration behind) {
    if (behind.inMinutes > 0) {
      return '${behind.inMinutes}m ${behind.inSeconds.remainder(60)}s';
    }
    return '${behind.inSeconds}s';
  }
}