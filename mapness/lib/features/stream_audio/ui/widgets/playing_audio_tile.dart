import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/cached_audio_progress_bar.dart';

class PlayingAudioTile extends ConsumerStatefulWidget {
  const PlayingAudioTile({super.key});

  @override
  ConsumerState<PlayingAudioTile> createState() => _PlayingAudioTileState();
}

class _PlayingAudioTileState extends ConsumerState<PlayingAudioTile> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);

    return Column(
      children: [
        // Your existing row with enhanced live indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16), // RadiusBorder.l replacement
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // RadiusBorder.baseSharp replacement
                      image: provider.selectedProgram?.programImage != null
                          ? DecorationImage(
                              image: AssetImage(provider.selectedProgram!.programImage.keyName),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                  'assets/images/audio_placeholders/panorama.png'), // Replace with Assets.images.audioPlaceholders.panorama.provider()
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.selectedProgram?.title ?? '-',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          provider.selectedProgram?.sub ?? '-',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),

                        // Enhanced status indicator with cache info
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: provider.isLive ? Colors.red : Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  provider.isLive
                                      ? (provider.isPlaying ? 'Live' : 'Live • Paused')
                                      : 'Behind ${_formatTimeBehind(provider)}',
                                  style: TextStyle(
                                    color: provider.isLive ? Colors.red : Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 10,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await ref.read(streamAudioProvider).togglePlayPause();
                    },
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : SvgPicture.asset(
                            provider.isPlaying
                                ? Assets.icons.svg.audio.pause.keyName
                                : Assets.icons.svg.audio.resume.keyName,
                          ),
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: SvgPicture.asset(Assets.icons.svg.audio.seekForward.keyName),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Cached Audio Progress Bar
        if (provider.selectedProgram != null) ...[
          const SizedBox(height: 16),
          CachedAudioProgressBar(
            onGoLive: () async {
              await ref.read(streamAudioProvider).goLive();
            },
          ),
        ],

        // Error display if any
        if (provider.hasError) ...[
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Stream Error: ${provider.errorMessage ?? "Connection issue"}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(streamAudioProvider).goLive();
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatTimeBehind(StreamAudioProvider provider) {
    final behind = provider.bufferedDuration - provider.currentPosition;
    if (behind.inMinutes > 0) {
      return '${behind.inMinutes}m ${behind.inSeconds.remainder(60)}s';
    }
    return '${behind.inSeconds}s';
  }
}
