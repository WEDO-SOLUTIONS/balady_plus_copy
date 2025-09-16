import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class PlayingAudioTile extends ConsumerStatefulWidget {
  const PlayingAudioTile({super.key});

  @override
  ConsumerState<PlayingAudioTile> createState() => _PlayingAudioTileState();
}

class _PlayingAudioTileState extends ConsumerState<PlayingAudioTile> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: RadiusBorder.l),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.baseSharp),
                  image: provider.selectedProgram?.programImage != null
                      ? DecorationImage(
                          image: AssetImage(
                              provider.selectedProgram!.programImage.keyName),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: Assets.images.audioPlaceholders.panorama
                              .provider(),
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
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  // Seek backward functionality can be added later if needed
                },
                child: SvgPicture.asset(
                    Assets.icons.svg.audio.seekBackward.keyName),
              ),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : SvgPicture.asset(
                        provider.isPlaying
                            ? Assets.icons.svg.audio.pause.keyName
                            : Assets.icons.svg.audio.resume.keyName,
                      ),
              ),
              GestureDetector(
                onTap: () async {
                  await ref.read(streamAudioProvider).seekForward();
                },
                child: SvgPicture.asset(
                    Assets.icons.svg.audio.seekForward.keyName),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
