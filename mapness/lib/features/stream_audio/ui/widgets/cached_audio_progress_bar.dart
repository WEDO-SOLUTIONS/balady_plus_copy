import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class LiveRadioProgressBar extends ConsumerStatefulWidget {
  final VoidCallback? onGoLive;

  const LiveRadioProgressBar({super.key, this.onGoLive});

  @override
  ConsumerState<LiveRadioProgressBar> createState() => _LiveRadioProgressBarState();
}

class _LiveRadioProgressBarState extends ConsumerState<LiveRadioProgressBar> with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  double _dragProgress = 0.0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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

  void _goLive() {
    if (_isDragging) {
      setState(() => _isDragging = false);
    }
    ref.read(streamAudioProvider).goLive();
    widget.onGoLive?.call();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBarWidth = screenWidth - 40;

    final displayProgress = _isDragging ? _dragProgress : provider.progress;
    final isLive = !_isDragging && provider.isLive;
    final timeBehind = provider.timeBehindLive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          /// Time indicators
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                /// Current position
                _buildTimeText(_isDragging
                    ? _formatDuration(
                        Duration(milliseconds: (provider.totalCachedTime.inMilliseconds * _dragProgress).round()))
                    : provider.formattedCurrentPosition),

                const Spacer(),

                /// Status indicator
                if (!isLive && !_isDragging && timeBehind.inSeconds > 2) _buildTimeBehind(provider.formattedTimeBehind),

                /// Go Live button
                if (!isLive || (_isDragging && _dragProgress < 0.98)) _buildGoLiveButton(isLive),

                const Spacer(),

                /// Total cached time
                _buildTimeText(provider.formattedLivePosition),
              ],
            ),
          ),

          /// Progress bar
          GestureDetector(
            onHorizontalDragStart: (details) {
              setState(() {
                _isDragging = true;
                _dragProgress = (details.localPosition.dx / progressBarWidth).clamp(0.0, 1.0);
              });
            },
            onHorizontalDragUpdate: (details) {
              setState(() => _dragProgress = (details.localPosition.dx / progressBarWidth).clamp(0.0, 1.0));
            },
            onHorizontalDragEnd: (details) {
              final targetPosition =
                  Duration(milliseconds: (provider.totalCachedTime.inMilliseconds * _dragProgress).round());

              ref.read(streamAudioProvider).seekToPosition(targetPosition);

              setState(() => _isDragging = false);
            },
            onTapUp: (details) {
              final progress = (details.localPosition.dx / progressBarWidth).clamp(0.0, 1.0);

              if (progress >= 0.98) {
                // Tap near end goes live
                ref.read(streamAudioProvider).goLive();
                widget.onGoLive?.call();
              } else {
                ref.read(streamAudioProvider).seekToProgress(progress);
              }
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // Track background
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Progress fill
                  AnimatedContainer(
                    duration: _isDragging ? Duration.zero : const Duration(milliseconds: 100),
                    height: 4,
                    width: progressBarWidth * displayProgress,
                    decoration: BoxDecoration(
                      color: isLive ? Colors.red : Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isLive
                          ? [BoxShadow(color: Colors.red.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1)]
                          : null,
                    ),
                  ),

                  // Thumb indicator
                  _ThumbIndicator(
                    isDragging: _isDragging,
                    progressBarWidth: progressBarWidth,
                    displayProgress: displayProgress,
                    isLive: isLive,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeText(String time) => Text(
        time,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _buildGoLiveButton(bool isLive) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: GestureDetector(
          onTap: _goLive,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.2),
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLive)
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                const Text(
                  'GO LIVE',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTimeBehind(String timeBehind) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Behind $timeBehind',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

class _ThumbIndicator extends StatelessWidget {
  const _ThumbIndicator(
      {required this.isDragging, required this.progressBarWidth, required this.displayProgress, required this.isLive});
  final bool isDragging;
  final double progressBarWidth;
  final double displayProgress;
  final bool isLive;

  @override
  Widget build(BuildContext context) => AnimatedPositioned(
        duration: isDragging ? Duration.zero : const Duration(milliseconds: 100),
        left: (progressBarWidth * displayProgress) - 10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isDragging ? 12 : 8,
              height: isDragging ? 12 : 8,
              decoration: BoxDecoration(
                color: isLive ? Colors.red : Colors.grey[800],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
}
