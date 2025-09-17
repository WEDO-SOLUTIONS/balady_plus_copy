import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class CachedAudioProgressBar extends ConsumerStatefulWidget {
  final VoidCallback? onGoLive;

  const CachedAudioProgressBar({
    Key? key,
    this.onGoLive,
  }) : super(key: key);

  @override
  ConsumerState<CachedAudioProgressBar> createState() => _CachedAudioProgressBarState();
}

class _CachedAudioProgressBarState extends ConsumerState<CachedAudioProgressBar> {
  bool _isDragging = false;
  double _dragProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);

    // Use drag progress when dragging, otherwise use actual progress
    final displayProgress = _isDragging ? _dragProgress : provider.progress;
    final isNearLive = displayProgress >= 0.98;
    // final isAtStart = displayProgress <= 0.02;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Time and cache info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Current time
              Text(
                _isDragging
                    ? _formatDuration(Duration(milliseconds: (provider.bufferedDuration.inMilliseconds * _dragProgress).round()))
                    : provider.formattedCurrentPosition,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Cache status
              Text(
                'Buffer: ${provider.formattedBufferedDuration} / ${provider.formattedMaxCache}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),

              // Total buffered time
              Text(
                provider.formattedBufferedDuration,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Main progress bar
          SizedBox(
            height: 30,
            child: Row(
              children: [
                // Live status indicator
                Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: (provider.isLive && !_isDragging)
                      ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : Container(),
                ),

                const SizedBox(width: 8),

                // Progress bar with gesture detection
                Expanded(
                  child: GestureDetector(
                    onPanStart: (details) {
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
                        // Seek to the dragged position
                        if (_dragProgress >= 0.98) {
                          ref.read(streamAudioProvider).goLive();
                          if (widget.onGoLive != null) {
                            widget.onGoLive!();
                          }
                        } else {
                          ref.read(streamAudioProvider).seekToProgress(_dragProgress);
                        }

                        setState(() {
                          _isDragging = false;
                        });
                      }
                    },
                    onTapDown: (details) {
                      final progress = _calculateProgress(details.localPosition.dx);

                      if (progress >= 0.98) {
                        ref.read(streamAudioProvider).goLive();
                        if (widget.onGoLive != null) {
                          widget.onGoLive!();
                        }
                      } else {
                        ref.read(streamAudioProvider).seekToProgress(progress);
                      }
                    },
                    child: Container(
                      height: 20,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          // Background track
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Cached/Buffered portion (always full width since we have the content)
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Played portion (white when behind live, red when live)
                          FractionallySizedBox(
                            widthFactor: displayProgress,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: (provider.isLive && !_isDragging) ? Colors.red : Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // Progress thumb (always visible for cached audio)
                          Positioned(
                            left: (MediaQuery.of(context).size.width - 116) * displayProgress - 6, // Account for margins
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: isNearLive ? Colors.red : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Go Live button (always visible unless live)
                SizedBox(
                  width: 50,
                  child: (!provider.isLive || _isDragging)
                      ? GestureDetector(
                    onTap: () {
                      ref.read(streamAudioProvider).goLive();
                      if (widget.onGoLive != null) {
                        widget.onGoLive!();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isNearLive ? Colors.red.withValues(alpha:0.8) : Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                            color: isNearLive ? Colors.red : Colors.white.withValues(alpha: 0.5)
                        ),
                      ),
                      child: Text(
                        'LIVE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isNearLive ? Colors.white : Colors.white.withValues(alpha: 0.9),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                ),
              ],
            ),
          ),

          // Visual feedback for dragging
          // if (_isDragging)
          //   Container(
          //     margin: const EdgeInsets.only(top: 4),
          //     child: Text(
          //       isNearLive
          //           ? 'Release to go LIVE'
          //           : isAtStart
          //           ? 'At start of cache (${_formatDuration(Duration(milliseconds: (provider.bufferedDuration.inMilliseconds * _dragProgress).round()))})'
          //           : 'Scrubbing: ${_formatDuration(Duration(milliseconds: (provider.bufferedDuration.inMilliseconds * _dragProgress).round()))}',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: isNearLive ? Colors.red : Colors.white.withOpacity(0.7),
          //         fontSize: 10,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  double _calculateProgress(double localX) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Account for padding and button widths
    final progressBarWidth = screenWidth - 132; // 16*2 padding + 50*2 buttons + 8*2 spacing
    final progress = localX / progressBarWidth;
    return progress.clamp(0.0, 1.0);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours);
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}